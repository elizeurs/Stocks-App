//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import Foundation

// ["AAPL", "MSFT", "SNAP"]
// [AAPL: Apple Inc.]

/// Object to manage saved caches
final class PersistenceManager {
  
  /// Singleton
  static let shared = PersistenceManager()
  
  /// Reference to user defaults
  private let userDefaults: UserDefaults = .standard
  
  /// Constants
  private struct Constants {
    static let onboardedKey = "hasOnboarded"
    static let watchListKey = "watchlist"
  }
  
  /// Privatized constructor
  private init() {}
  
  // MARK: - Public
  
  /// Get usr watch list
  public var watchlist: [String] {
    if !hasOnboarded {
      userDefaults.set(true, forKey: Constants.onboardedKey)
      setUpDefaults()
    }
    return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
  }
  
  /// Check if watch list contains item
  /// - Parameter symbol: Symbol to check
  /// - Returns: Boolean
  public func watchlistContains(symbol: String) -> Bool {
    return watchlist.contains(symbol)
  }
  
  /// Add a symbol to watch list
  /// - Parameters:
  ///   - symbol: Symbol to add
  ///   - companyName: Company name for symbol being added
  public func addToWatchlist(symbol: String, companyName: String) {
    var current = watchlist
    current.append(symbol)
    userDefaults.set(current, forKey: Constants.watchListKey)
    userDefaults.set(companyName, forKey: symbol)
    
    NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
  }
  
  /// Remove item from watchlist
  /// - Parameter symbol: Symbol
  public func removeFromWatchlist(symbol: String) {
    var newList = [String]()
    
//    print("Deleting: \(symbol)")
    
    userDefaults.set(nil, forKey: symbol)
    for item in watchlist where item != symbol {
//      print("\n\(item)")
      newList.append(item)
    }
    
    userDefaults.set(newList, forKey: Constants.watchListKey)
  }
  
  // MARK: - Private
  
  /// Check if user has been onboarded
  private var hasOnboarded: Bool {
    return userDefaults.bool(forKey: "hasOnboarded")
//    return false
  }
  
  /// Set up defaults watch list items
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
