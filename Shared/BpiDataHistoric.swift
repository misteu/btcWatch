//
//  BpiDataHistoric.swift
//  btcwatch
//
//  Created by skrr on 26.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit
import WatchKit

/// Typealias representing a sorted array of tuples with historic bpi data
typealias SortedHistoricData = [HistoricData]

/// Typealias representing a tuple with historic bpi data
typealias HistoricData = (date: String, price: Double)

/// Class for historic BTC/EUR data
/// - if initialized without parameters, static var BpiDataHistoric.sorted holds cached data (if available) as a sorted array of tuples
/// - if initalized with jsonData, static var BpiDataHistoric.sorted holds a sorted array of tuples for the given json data

class BpiDataHistoric {
  
  let decoded: DecodedBpiData?
  
  /// An array of tuples with dates and historic close rates for BTC/EUR sorted by date ascending
  /// - first parameter is date as String
  /// - second parameter is rate as Double
  static var sorted: [(String,Double)]?

  struct DecodedBpiData: Decodable {
    let bpi: [String:Double]
  }
  
  /// initializes BpiDataHistoric with JSON Response from coindesk-api, handles wrong jsons with console error
  ///
  ///       if BpiData(jsonData: data).decoded != nil {
  ///         // get date for most recent historical close rate
  ///         let date = BpiData.sorted?[0].0
  ///         // get price for most recent historical close rate
  ///         let price = BpiData.sorted?[0].1
  ///       }
  ///
  /// - Parameters:
  ///     - jsonData: JSON object from coindesk-api historical/close.json endpoint

  init(jsonData: Data) {
    do {
      self.decoded = try JSONDecoder().decode(DecodedBpiData.self, from: jsonData)
      
      if let decoded = self.decoded {
        
        // sort unsorted dates descending for easier visualization
        BpiDataHistoric.sorted = decoded.bpi.sorted(by: { $0.key > $1.key })
      }
      
      // cache json data for next app startup
      BpiData.sharedDefaults?.set(jsonData, forKey: UserDefaults.cachedBpiData.historicRates)
      
    } catch let error {
      self.decoded = nil
      print(error)
    }
  }
  
  /// initializes BpiDataHistoric with cached JSON Response from coindesk-api, handles wrong jsons with console error
  ///
  ///       if BpiData(jsonData: data).decoded != nil {
  ///         // get date for most recent historical close rate
  ///         let date = BpiData.sorted?[0].0
  ///         // get price for most recent historical close rate
  ///         let price = BpiData.sorted?[0].1
  ///       }
  ///
  /// - Parameters:
  ///     - jsonData: JSON object from coindesk-api historical/close.json endpoint
  init() {
    
    if let cached = BpiData.sharedDefaults?.data(forKey: UserDefaults.cachedBpiData.historicRates) {
      
      do {
        self.decoded = try JSONDecoder().decode(DecodedBpiData.self, from: cached)
        
        if let decoded = self.decoded {
          
          // sort unsorted dates descending for easier visualization
          BpiDataHistoric.sorted = decoded.bpi.sorted(by: { $0.key > $1.key })
        }
        
      } catch let error {
        self.decoded = nil
        print(error)
      }
    } else {
      self.decoded = nil
    }
  }
}
