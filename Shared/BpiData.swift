//
//  BpiRate.swift
//  btcwatch
//
//  Created by skrr on 26.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit
import WatchKit


/// Model for current BTC/EUR rate
/// - if initialized without parameters, static var BpiData.shared holds decoded data from cache (if available)
/// - if initalized with jsonData, static var BpiData.shared holds decoded data for that given json
class BpiData {
  
  static let sharedDefaults = UserDefaults.init(suiteName: UserDefaults.sharedGroup)
  
  let decoded: CurrentBpiRate?
  
  /// Holds decoded JSON data for time and exchangeRate (in EUR and USD)
  static var shared: CurrentBpiRate?
  
  struct CurrentBpiRate: Decodable {
    let time: Time
    let exchangeRate: ExchangeRate
    
    enum CodingKeys: String, CodingKey {
      case time
      case exchangeRate = "bpi"
    }
  }
  
  struct Time: Decodable {
    let updated: String
    let updatedISO: String
    let updateduk: String
  }
  
  struct ExchangeRate: Decodable {
    let eur: Currency
    let usd: Currency
    
    enum CodingKeys: String, CodingKey {
      case eur = "EUR"
      case usd = "USD"
    }
  }
  
  struct Currency: Decodable {
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
      case rate = "rate_float"
    }
  }
  
  /// initializes BpiData with JSON Response from coindesk-api, handles wrong JSON with console error, decodes JSON object to Swift Object
  ///
  ///       if BpiData(jsonData: data).decoded != nil {
  ///
  ///         // get timestamp of last bpi request
  ///         let date = BpiData.shared?.time.updated
  ///         // get price of last bpi request
  ///         let price = BpiData.shared?.exchangeRate.eur.rate
  ///
  ///       }
  ///
  /// - Parameters:
  ///     - jsonData: JSON object from coindesk-api historical/close.json endpoint
  ///
  
  init(jsonData: Data) {
    do {
      self.decoded = try JSONDecoder().decode(CurrentBpiRate.self, from: jsonData)
      BpiData.shared = self.decoded
    
      // cache json data for next startup
      
      // cache json data for next startup
        BpiData.sharedDefaults?.set(jsonData, forKey: UserDefaults.cachedBpiData.lastCurrentRate)
      
//      UserDefaults.standard.set(jsonData, forKey: UserDefaults.cachedBpiData.lastCurrentRate)
      
    } catch let error {
      self.decoded = nil
      print(error)
    }
  }
  
  /// initializes BpiData with cached JSON Response from coindesk-api, handles wrong JSON with console error, decodes JSON object to Swift Object
  ///
  ///     if BpiData().decoded != nil {
  ///       // get cached timestamp of last bpi request
  ///       let date = BpiData.shared?.time.updated
  ///       // get cached eur price of last bpi request
  ///       let price = BpiData.shared?.exchangeRate.eur.rate
  ///     }
  init() {
    
    if let cached = BpiData.sharedDefaults?.data(forKey: UserDefaults.cachedBpiData.lastCurrentRate) {
      do {
        self.decoded = try JSONDecoder().decode(CurrentBpiRate.self, from: cached)
        if let decoded = self.decoded {
          BpiData.shared = decoded
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
