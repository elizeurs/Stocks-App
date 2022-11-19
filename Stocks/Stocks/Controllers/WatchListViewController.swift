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
  
  // Model
  private var watchlistMap: [String: [CandleStick]] = [:]
  
  // ViewModels
  private var viewModels: [WatchListTableViewCell.ViewModel] = []
  
  private let tableView: UITableView = {
    let table = UITableView()
    
    return table
  }()
  
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
    //    setUpChild()
  }
  
  // MARK: - Private
  
  private func fetchWatchlistData() {
    let symbols = PersistenceManager.shared.watchlist
    
    let group = DispatchGroup()
    
    for symbol in symbols {
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
          changePercentage: .percentage(from: changePercentage)
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
    let vc = StockDetailsViewController()
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
    return watchlistMap.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // Open Details for selection
  }
}
