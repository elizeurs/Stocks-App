//
//  ViewController.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit

class WatchListViewController: UIViewController {
  
  private var searchTimer: Timer?
  
  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
//    view.backgroundColor = .systemRed
    view.backgroundColor = .systemBackground
    setUpSearchController()
    setUpTitleView()
  }
  
  // MARK: - Private
  
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
    // Present stock details for given selection
    print("Did select: \(searchResult.displaySymbol)")
  }
}
