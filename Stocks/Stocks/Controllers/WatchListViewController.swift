//
//  ViewController.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit
import FloatingPanel

/// VC to render user watch list
final class WatchListViewController: UIViewController {
  
  /// Timer to optimize searching
  private var searchTimer: Timer?
  
  /// Floating news panel
  private var panel: FloatingPanelController?
  
  /// Width to track change label geometry
  static var maxChangeWidth: CGFloat = 0 
  
  /// Model
  private var watchlistMap: [String: [CandleStick]] = [:]
  
  /// ViewModels
  private var viewModels: [WatchListTableViewCell.ViewModel] = []
  
  /// Main view to render watch list
  private let tableView: UITableView = {
    let table = UITableView()
    table.register(WatchListTableViewCell.self, forCellReuseIdentifier: WatchListTableViewCell.identifier)
    return table
  }()
  
  /// Observer for watch list updates
  private var observer: NSObjectProtocol?
  
  // MARK: - Lifecycle
  
  /// <#Description#>
  override func viewDidLoad() {
    super.viewDidLoad()
    //    view.backgroundColor = .systemRed
    view.backgroundColor = .systemBackground
    setUpSearchController()
    setUpTableView()
    fetchWatchlistData()
    setUpFloatingPanel()
    setUpTitleView()
    setUpObserver()
    //    setUpChild()
  }
  
  /// Layout subviews
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  // MARK: - Private
  
  /// Sets up observer for watch list updates
  private func setUpObserver() {
    observer = NotificationCenter.default.addObserver(
      forName: .didAddToWatchList,
      object: nil,
      queue: .main,
      using: { [weak self] _ in
        self?.viewModels.removeAll()
        self?.fetchWatchlistData()
      })
  }
  
  /// Fetch watch list models
  private func fetchWatchlistData() {
    let symbols = PersistenceManager.shared.watchlist
    
    createPlaceholderViewModels()
    
    let group = DispatchGroup()
    
    for symbol in symbols where watchlistMap[symbol] == nil {
      // Fetch market data per symbol
      group.enter()
      
      APICaller.shared.marketData(for: symbol) { [weak self] result in
        // defer - Swift's defer keyword lets us set up some work to be performed when the current scope exits. For example, you might want to make sure that some temporary resources are cleaned up once a method exits, and defer will make sure that happens no matter how that exit happens.
        defer {
          group.leave()
        }
        
        switch result {
        case .success(let data):
          let candleSticks = data.candleSticks
          self?.watchlistMap[symbol] = candleSticks
        case .failure(let error):
          print(error)
        }
      }
    }
    group.notify(queue: .main) { [weak self] in
      self?.createViewModels()
      self?.tableView.reloadData()
  }
}
  
  private func createPlaceholderViewModels() {
    let symbols = PersistenceManager.shared.watchlist
    symbols.forEach { item in
      viewModels.append(
        .init(symbol: item,
              companyName: UserDefaults.standard.string(forKey: item) ?? "Company",
              price: "0.00",
              changeColor: .systemGreen,
              changePercentage: "0.00",
              chartViewModel: .init(data: [],
                                    showLegend: false,
                                    showAxis: false,
                                    fillColor: .clear
                                   )
             )
      )
    }
    
    self.viewModels = viewModels.sorted(by: { $0.symbol < $1.symbol })
    tableView.reloadData()
  }
  
  /// Creates view models from models
  private func createViewModels() {
    var viewModels = [WatchListTableViewCell.ViewModel]()
    
    for(symbol, candleSticks) in watchlistMap {
      let changePercentage = candleSticks.getPercentage()
      
      viewModels.append(
        .init(
          symbol: symbol,
          companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
          price: getLatestClosingPrice(from: candleSticks),
          changeColor: changePercentage < 0 ? .systemRed : .systemGreen,
          changePercentage: .percentage(from: changePercentage),
          chartViewModel: .init(
            data: candleSticks.reversed().map { $0.close },
            showLegend: false,
            showAxis: false,
            fillColor: changePercentage < 0 ? .systemRed : .systemGreen
          )
        )
      )
    }
    
//    print("\n\n\(viewModels)\n\n")
    
    self.viewModels = viewModels.sorted(by: { $0.symbol < $1.symbol })
  }
  
  /// Gets latest closing price
  /// - Parameter data: Collection of data
  /// - Returns: String
  private func getLatestClosingPrice(from data: [CandleStick]) -> String {
    guard let closingPrice = data.first?.close else {
      return ""
    }
    
    return .formatted(number: closingPrice)
  }
  
  /// Sets up tableview
  private func setUpTableView() {
    view.addSubviews(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  /// Sets up floating news panel
  private func setUpFloatingPanel() {
    let vc = NewsViewController(type: .topStories)
//    let vc = NewsViewController(type: .company(symbol: "SNAP"))
    let panel = FloatingPanelController(delegate: self)
    panel.surfaceView.backgroundColor = .secondarySystemBackground
    panel.set(contentViewController: vc)
    panel.addPanel(toParent: self)
    panel.track(scrollView: vc.tableView)
  }
  
//  private func setUpChild() {
//    let vc = PanelViewController()
//    addChild(vc)
//
//    view.addSubview(vc.view)
//    vc.view.frame = CGRect(x: 0, y: view.height/2, width: view.width, height: view.height)
//    vc.didMove(toParent: self)
//  }
  
  /// Set up custom view
  private func setUpTitleView() {
    let titleView = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
//        width: view.frame.size.width,
        width: view.width,
//        height: 100
        height: navigationController?.navigationBar.height ?? 100
      )
    )
//    titleView.backgroundColor = .link
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width-20, height: titleView.height))
    label.text = "Stocks"
    label.font = .systemFont(ofSize: 40, weight: .medium)
    titleView.addSubview(label)
    
    navigationItem.titleView = titleView
  }
  
  /// Set up search and results controlller
  private func setUpSearchController() {
    let resultVC = SearchResultsViewController()
    resultVC.delegate = self
    let searchVC = UISearchController(searchResultsController: resultVC)
    searchVC.searchResultsUpdater = self
    navigationItem.searchController = searchVC
  }
}

// MARK: - UISearchResultsUpdating

extension WatchListViewController: UISearchResultsUpdating {
  
  /// Update search on key tap
  /// - Parameter searchController: Ref of the search controller
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text,
    let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
    !query.trimmingCharacters(in: .whitespaces).isEmpty else {
      return
    }
    
    // Reset timer
    searchTimer?.invalidate()
    
      // Kick off new timer
    // Optimize to reduce number of searches for when user stops typing
    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
      // Call API to search
      APICaller.shared.search(query: query) { result in
        switch result {
        case .success(let response):
          DispatchQueue.main.async {
            // Update results controller
            resultsVC.update(with: response.result)
          }
        case .failure(let error):
          DispatchQueue.main.async {
            resultsVC.update(with: [])
          }
          print(error)
        }
      }
    })
  }
}

// MARK: - SearchResultsViewControllerDelegate

extension WatchListViewController: SearchResultsViewControllerDelegate {
//  func searchResultsViewControllerDidSelect(searchResult: String) {
  
  /// Notify of search result selection
  /// - Parameter searchResult: Search result that was selected
  func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
    // dismiss keyboard
    navigationItem.searchController?.searchBar.resignFirstResponder()
    
    HapticsManager.shared.vibrateForSelection()
    
    // Present stock details for given selection
    let vc = StockDetailsViewController(
      symbol: searchResult.displaySymbol,
      companyName: searchResult.description
    )
    let navVC = UINavigationController(rootViewController: vc)
    vc.title = searchResult.description
    present(navVC, animated: true)
//    print("Did select: \(searchResult.displaySymbol)")
  }
}

// MARK: - FloatingPanelControllerDelegate

extension WatchListViewController: FloatingPanelControllerDelegate {
  /// Gets floating panel state change
  /// - Parameter fpc: Ref of controller
  func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
    navigationItem.titleView?.isHidden = fpc.state == .full
  }
}

// MARK: - TableView

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: WatchListTableViewCell.identifier,
      for: indexPath
    ) as? WatchListTableViewCell else {
      fatalError()
    }
    cell.delegate = self
    cell.configure(with: viewModels[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return WatchListTableViewCell.preferredHeight
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      tableView.beginUpdates()
      
      // Update persistence
      PersistenceManager.shared.removeFromWatchlist(symbol: viewModels[indexPath.row].symbol)
      
      // Update viewModels
      viewModels.remove(at: indexPath.row)
      
      // Delete Row
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    HapticsManager.shared.vibrateForSelection()
    
    // Open Details for selection
    let viewModel = viewModels[indexPath.row]
    let vc = StockDetailsViewController(
      symbol: viewModel.symbol,
      companyName: viewModel.companyName,
      candleStickData: watchlistMap[viewModel.symbol] ?? []
    )
    let navVC = UINavigationController(rootViewController: vc)
    present(navVC, animated: true)
  }
}

// MARK: - WatchListTableViewCellDelegate

extension WatchListViewController: WatchListTableViewCellDelegate {
  
  /// Notify delegate of change label width
  func didUpdateMaxWidth() {
    // Optimize: Only refresh rows prior to the current row that changes the max width
    tableView.reloadData()
  }
}
