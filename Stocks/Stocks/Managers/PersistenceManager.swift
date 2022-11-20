//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import Foundation

// ["AAPL", "MSFT", "SNAP"]
// [AAPL: Apple Inc.]
final class PersistenceManager {
  static let shared = PersistenceManager()
  
  private let userDefaults: UserDefaults = .standard
  
  private struct Constants {
    static let onboardedKey = "hasOnboarded"
    static let watchListKey = "watchlist"
  }
  
  private init() {}
  
  // MARK: - Public
  
  public var watchlist: [String] {
    if !hasOnboarded {
      userDefaults.set(true, forKey: Constants.onboardedKey)
      setUpDefaults()
    }
    return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
  }
  
  public func addToWatchlist() {
    
  }
  
  public func removeFromWatchlist() {
    
  }
  
  // MARK: - Private
  
  private var hasOnboarded: Bool {
    return userDefaults.bool(forKey: "hasOnboarded")
//    return false
  }
  
  private func setUpDefaults() {
    let map: [String: String] = [
      "AAPL": "Apple Inc.",
      "MSFT": "Microsoft Corporation",
      "SNAP": "Snap Inc.",
      "GOOG": "Alphabet",
      "AMZN": "Amazon.com, Inc.",
      "WORK": "Slac Tecnologies",
      "FB": "Facebook Inc.",
      "NVDA": "Nvidia Inc.",
      "NKE": "Nike",
      "PINS": "Pinterest Inc.",
    ]
    
    let symbols = map.keys.map { $0 }
    userDefaults.set(symbols, forKey: Constants.watchListKey)
    
    for (symbol, name) in map {
      userDefaults.set(name, forKey: symbol)
    }
  }
}
