//
//  ViewController.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
  
  private var searchTimer: Timer?
  
  private var panel: FloatingPanelController?
  
  static var maxChangeWidth: CGFloat = 0 
  
  // Model
  private var watchlistMap: [String: [CandleStick]] = [:]
  
  // ViewModels
  private var viewModels: [WatchListTableViewCell.ViewModel] = []
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.register(WatchListTableViewCell.self, forCellReuseIdentifier: WatchListTableViewCell.identifier)
    return table
  }()
  
  private var observer: NSObjectProtocol?
  
  // MARK: - Lifecycle
  
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
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  // MARK: - Private
  
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
  
  private func fetchWatchlistData() {
    let symbols = PersistenceManager.shared.watchlist
    
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
  
  private func createViewModels() {
    var viewModels = [WatchListTableViewCell.ViewModel]()
    
    for(symbol, candleSticks) in watchlistMap {
      let changePercentage = getChangePercentage(
        symbol: symbol,
        data: candleSticks
      )
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
    
    self.viewModels = viewModels
  }
  
  private func getChangePercentage(symbol: String, data: [CandleStick]) -> Double {
    let latestDate = data[0].date
    guard let latestClose = data.first?.close,
            let priorClose = data.first(where: {
              !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
    })?.close else {
      return 0
    }
    
    let diff = 1 - (priorClose/latestClose)
//    print("\(symbol): \(diff)%")
    return diff
  }
  
  private func getLatestClosingPrice(from data: [CandleStick]) -> String {
    guard let closingPrice = data.first?.close else {
      return ""
    }
    
    return .formatted(number: closingPrice)
  }
  
  private func setUpTableView() {
    view.addSubviews(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
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
  
  private func setUpSearchController() {
    let resultVC = SearchResultsViewController()
    resultVC.delegate = self
    let searchVC = UISearchController(searchResultsController: resultVC)
    searchVC.searchResultsUpdater = self
    navigationItem.searchController = searchVC
  }
}

extension WatchListViewController: UISearchResultsUpdating {
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

extension WatchListViewController: SearchResultsViewControllerDelegate {
//  func searchResultsViewControllerDidSelect(searchResult: String) {
  func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
    // dismiss keyboard
    navigationItem.searchController?.searchBar.resignFirstResponder()
    
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

extension WatchListViewController: FloatingPanelControllerDelegate {
  func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
    navigationItem.titleView?.isHidden = fpc.state == .full
  }
}

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

extension WatchListViewController: WatchListTableViewCellDelegate {
  func didUpdateMaxWidth() {
    // Optimize: Only refresh rows prior to the current row that changes the max width
    tableView.reloadData()
  }
}
