//
//  HapticsManager.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import Foundation
import UIKit

// final - this term, basically means that, no other class, in our project, can subclass HapticsManager
final class HapticsManager {
  static let shared = HapticsManager()
  
  private init() {}
  
  // MARK: - Public
  
  public func vibrateForSelection() {
    // Vibrate lightly for a selection tap interaction
  }
  
  // vibrate for type
}
