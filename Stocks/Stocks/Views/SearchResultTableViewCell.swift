//
//  SearchResultTableViewCell.swift
//  Stocks
//
//  Created by Elizeu RS on 06/11/22.
//

import UIKit

/// Tableview cell for search result
class SearchResultTableViewCell: UITableViewCell {
  /// Identifier for cell
  static let identzifier = "SearchResultTableViewCell"
  
  // MARK: - Init

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
