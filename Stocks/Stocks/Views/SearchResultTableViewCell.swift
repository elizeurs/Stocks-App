//
//  SearchResultTableViewCell.swift
//  Stocks
//
//  Created by Elizeu RS on 06/11/22.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
  static let identifier = "SearchResultTableViewCell"

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
