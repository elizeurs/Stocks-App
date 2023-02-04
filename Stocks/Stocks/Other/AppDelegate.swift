//
//  AppDelegate.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  
  /// Gets called when app launches
  /// - Parameters:
  ///   - application: App instance
  ///   - launchOptions: Launch properties
  /// - Returns: Boll for success of failure
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // https://finnhub.io/api/v1/search?q=Apple&token=cdkip12ad3idmsqf0t5gcdkip12ad3idmsqf0t60
//    APICaller.shared.search(query: "Apple") { _ in
//    APICaller.shared.search(query: "Apple") { result in
//      switch result {
//      case .success(let response):
//        print(response.result)
//      case .failure(let error):
//        print(error)
//      }
//    }
    
//    debug()
    
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    private func debug() {
      
//      APICaller.shared.marketData(for: "AAPL", numberOfDays: 1) { result in
//        switch result {
//        case .success(let data):
//          let candleSticks = data.candleSticks
//        case .failure(let error):
//          print(error)
//        }
//      }
      
////      APICaller.shared.news(for: .topStories) { result in
//      APICaller.shared.news(for: .company(symbol: "MSFT")) { result in
//        switch result {
//        case .success(let news):
//          print(news.count)
//        case .failure: break
//        }
////        print(result)
//      }
    }
  }

