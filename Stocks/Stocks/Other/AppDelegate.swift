//
//  AppDelegate.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



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
    
    debug()
    
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
      
    }
  }

