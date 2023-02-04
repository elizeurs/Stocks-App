//
//  TopStoriesNewsViewController.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit
import SafariServices

/// Controller to show news
final class NewsViewController: UIViewController {
  
  /// Type of news
  enum `Type` {
  case topStories
  case company(symbol: String)
    
    /// Title for given type
    var title: String {
      switch self {
      case .topStories:
        return "Top Stories"
      case .company(let symbol):
        return symbol.uppercased()
      }
    }
  }
  
  // MARK: - Properties
  
  /// Collection of models
  private var stories = [NewsStory]()
  
//  private var stories = [String]()
//  private var stories = ["first"]
  // dummy news story
//  private var stories: [NewsStory] = [
//    NewsStory(category: "tech",
//              datetime: 123,
//              headline: "Some headline should go here!",
//              image: "",
//              related: "Related",
//              source: "CNBC",
//              summary: "",
//              url: ""
//             )
//  ]
  
  /// Instance of a type
  private let type: Type
  
  // anonymous closure
  /// Primary news view
  let tableView: UITableView = {
    let table = UITableView()
    // Register cell, header
    table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
    table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
    table.backgroundColor = .clear
    return table
  }()
  
  // MARK: - Init
  
  /// Create VC with type
  init(type: Type) {
    self.type = type
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
      setUpTable()
      fetchNews()
    }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  // MARK: - Private
  
  /// Sets up tableview
  private func setUpTable() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  /// Fetch news models
  private func fetchNews() {
    APICaller.shared.news(for: type) { [weak self] result in
      switch result {
      case .success(let stories):
        // we always do UI work on the main thread.
        DispatchQueue.main.async {
          self?.stories = stories
          self?.tableView.reloadData()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  /// Open a story
  /// - Parameter url: URL to open
  private func open(url: URL) {
    // web view package to look like safari.
    let vc = SFSafariViewController(url: url)
    present(vc, animated: true)
  }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: NewsStoryTableViewCell.identifier,
      for: indexPath
    ) as? NewsStoryTableViewCell else {
      fatalError()
    }
    cell.configure(with: .init(model: stories[indexPath.row]))
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(
      withIdentifier: NewsHeaderView.identifier
    ) as? NewsHeaderView else {
      return nil
    }
    header.configure(with: .init(
      title: self.type.title,
      shouldShowAddButton: false
    ))
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 140
    return NewsStoryTableViewCell.preferredHeight
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 70
    return NewsHeaderView.preferredHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    HapticsManager.shared.vibrateForSelection()
    
    // Open news story
    let story = stories[indexPath.row]
    guard let url = URL(string: story.url) else {
      presentFailedToOpenAlert()
      return
    }
    open(url: url)
  }
  
  
  /// Present an alert to show an error occurred when opening story
  private func presentFailedToOpenAlert() {
    HapticsManager.shared.vibrate(for: .error)

    let alert = UIAlertController(
      title: "Unable to Open",
      message: "We were unable to open the article.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    present(alert, animated: true)
  }
}
