//
//  ViewController.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit

class WatchListViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
//    view.backgroundColor = .systemRed
    view.backgroundColor = .systemBackground
    setUpSearchController()
  }
  
  private func setUpSearchController() {
    let resultVC = SearchResultsViewController()
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
    
    // Optimize to reduce number of searches for when user stops typing
    
    // Call API to search
    
    // Update results controller
    
    
    print(query)
  }
}

