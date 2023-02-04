//
//  SearchResultsViewController.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit

/// Delegate for search results
protocol SearchResultsViewControllerDelegate: AnyObject {
  //  func searchResultsViewControllerDidSelect(searchResult: String)
  /// Notify delegate of selection
  /// - Parameter searchResult: Result that was picked
  func searchResultsViewControllerDidSelect(searchResult: SearchResult)
}

/// VC to show search results
class SearchResultsViewController: UIViewController {
  /// Delegate to get evnets
  weak var delegate: SearchResultsViewControllerDelegate?
  
  //  private var results: [String] = []
  /// Collection of results
  private var results: [SearchResult] = []

  
  // anonymous closure pattern
  /// Primary view
  private let tableView: UITableView = {
    let table = UITableView()
    // Register a cell
    table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    table.isHidden = true
    return table
  }()

  // MARK: - Lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .systemBackground
      setUpTable()
    }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  // MARK: - Private
  
  /// Set up our table view
  private func setUpTable() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - Public
  
  //  public func update(with results: [String]) {
  /// Update results on VC
  /// - Parameter results: Collection of news results
  public func update(with results: [SearchResult]) {
    self.results = results
    tableView.isHidden = results.isEmpty
    tableView.reloadData()
  }
}

//MARK: - TableView

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: SearchResultTableViewCell.identifier,
      for: indexPath
    )
    let model = results[indexPath.row]
    
//    cell.textLabel?.text = "AAPL"
    cell.textLabel?.text = model.displaySymbol
//    cell.detailTextLabel?.text = "Apple Inc."
    cell.detailTextLabel?.text = model.description

    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let model = results[indexPath.row]
//    delegate?.searchResultsViewControllerDidSelect(searchResult: "AAPL")
    delegate?.searchResultsViewControllerDidSelect(searchResult: model)
  }
}
