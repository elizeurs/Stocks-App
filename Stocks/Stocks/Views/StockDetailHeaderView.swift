//
//  StockDetailHeaderView.swift
//  Stocks
//
//  Created by Elizeu RS on 10/12/22.
//

import UIKit

/// Header for stock details
final class StockDetailHeaderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  /// Metrics viewModels
  private var metricViewModels: [MetricCollectionViewCell.ViewModel] = []
  
  // Subview

  /// ChartView
  private let chartView = StockChartView()
  
  /// CollectionView
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 0
//    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    collectionView.backgroundColor = .systemRed
    // Register cells
    collectionView.register(MetricCollectionViewCell.self,
                            forCellWithReuseIdentifier: MetricCollectionViewCell.identifier)
    collectionView.backgroundColor = .secondarySystemBackground
    return collectionView
  }()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    clipsToBounds = true
    addSubviews(chartView, collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  required init(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    chartView.frame = CGRect(x: 0, y: 0, width: width, height: height-100)
    collectionView.frame = CGRect(x: 0, y: height-100, width: width, height: 100)
  }
  
  /// Configure view
  /// - Parameters:
  ///   - chartViewModel: Chart view model
  ///   - metricViewModels: Collection of metric viewModels
  func configure(
    chartViewModel: StockChartView.ViewModel,
    metricViewModels: [MetricCollectionViewCell.ViewModel]
  ) {
    // Update chart
    chartView.configure(with: chartViewModel)
    self.metricViewModels = metricViewModels
    collectionView.reloadData()
  }
  
  // MARK: - CollectionView
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return metricViewModels.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let viewModel = metricViewModels[indexPath.row]
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCollectionViewCell.identifier, for: indexPath
    ) as? MetricCollectionViewCell else {
      fatalError()
    }
    cell.configure(with: viewModel)
//    cell.backgroundColor = .green
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: width/2, height: 100/3)
  }
}
