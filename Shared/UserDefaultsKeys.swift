//
//  UserDefaultsKeys.swift
//  btcwatch
//
//  Created by skrr on 27.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit
import WatchKit

extension UserDefaults {
  
  static let sharedGroup = "group.st.mic"
  
  /// Helper enum for UserDefaults keys
  enum cachedBpiData {
    static let historicRates = "cachedBpiHistoricRates"
    static let lastCurrentRate = "cachedBpiLastCurrentRate"
  }

}
