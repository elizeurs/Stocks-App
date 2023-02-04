//
//  HapticsManager.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import Foundation
import UIKit

// final - this term, basically means that, no other class, in our project, can subclass HapticsManager

/// Object to manage haptics
final class HapticsManager {
  
  /// Singleton
  static let shared = HapticsManager()
  
  /// Private constructor
  private init() {}
  
  // MARK: - Public
  
  /// Vibrate slightly for selection
  public func vibrateForSelection() {
    // Vibrate lightly for a selection tap interaction
  }
  
  // vibrate for type
}
