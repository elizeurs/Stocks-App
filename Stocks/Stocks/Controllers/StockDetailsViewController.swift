//
//  StockDetailsViewController.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit

class StockDetailsViewController: UIViewController {
  
  // MARK: - Properties
  
  // Symbol, Compay Name, Any chart data we may have.
  private let symbol: String
  private let companyName: String
  private var candleStickData: [CandleStick]
  
  // MARK: - Init
  
  init(
    symbol: String,
    companyName: String,
    candleStickData: [CandleStick] = []
  ) {
    self.symbol = symbol
    self.companyName = companyName
    self.candleStickData = candleStickData
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .systemBackground
    }

}
