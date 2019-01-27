//
//  API.swift
//  btcwatch
//
//  Created by skrr on 26.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit
import WatchKit


class API: NSURL {
  private static let baseUrl = "https://api.coindesk.com/v1/bpi/"
  private static let historicalClose = "historical/close.json"
  static let currentPriceEur = "https://api.coindesk.com/v1/bpi/currentprice/EUR"
  
  /// generates URL-string for historic bpi rates endpoint of coindesk
  /// - Parameters:
  ///   - start: start Date back in time
  ///   - toEnd: end date back in time or today
  /// - Returns: a coindesk API URL as a String for the given dates
  static func endpointForBpiRatesFrom(start: Date, toEnd: Date)->String {
    
    return "\(baseUrl+historicalClose)?start=\(start.toString(dateFormat: "yyyy-MM-dd"))&end=\(toEnd.toString(dateFormat: "yyyy-MM-dd"))"
    
  }
  
}
