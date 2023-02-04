//
//  SceneDelegate.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  
  /// Our main window
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

//    guard let _ = (scene as? UIWindowScene) else { return }
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: windowScene)
    let vc = WatchListViewController()
    let navVC = UINavigationController(rootViewController: vc)
    window.rootViewController = navVC
    window.makeKeyAndVisible()
    
    self.window = window
  }

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}

  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {}

  func sceneDidEnterBackground(_ scene: UIScene) {}


}

