//
//  Helper.swift
//  btcwatch
//
//  Created by skrr on 24.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit
import Alamofire

class Helper: NSObject {
  static let bpiRateCell = "cell"
  static let apiEndpoint = "https://api.coindesk.com/v1/bpi/historical/close.json"
  static var newestBpiData = [(String, Double)]()
  static var currentDateAndRate = [String:Double]()

  enum UserDefaultKeys {
    static let cachedBpiResponse = "cachedBpiResponse"
    static let cachedLastRate = "cachedLastRate"
  }
  
  
  static func getApiEndpointForBpiRatesFrom(start: Date, toEnd: Date)->String {
    
    return "\(Helper.apiEndpoint)?start=\(start.toString(dateFormat: "yyyy-MM-dd"))&end=\(toEnd.toString(dateFormat: "yyyy-MM-dd"))"
    
  }
  
  static func requestLastBpiRatesFor(days: Int, group: DispatchGroup) {
    
    let daysBack = Date().daysBackFromNow(days: days)
    let bpiHistoricRatesEndpoint = Helper.getApiEndpointForBpiRatesFrom(start: daysBack, toEnd: Date())
    
    Alamofire.request(bpiHistoricRatesEndpoint).responseJSON { response in

      if let json = response.result.value as? NSDictionary {
        print("JSON: \(json)") // serialized json response
        
        // parse JSON, get bpi rates
        if let bpiRates = json["bpi"] as? [String:Double] {
          
          let defaults = UserDefaults.standard
          Helper.newestBpiData = bpiRates.sorted(by: { $0.key > $1.key })
          
          defaults.set(bpiRates, forKey: Helper.UserDefaultKeys.cachedBpiResponse)
          
        } else {
          print("wrong JSON parsing")
        }
      }
      
      if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
        print("Data: \(utf8Text)") // original server data as UTF8 string
      }
    group.leave()
    }
  }
  
  static func requestCurrentBpiEurRate(group: DispatchGroup) {
    
    let endpoint = "https://api.coindesk.com/v1/bpi/currentprice/EUR"
    
    Alamofire.request(endpoint).responseJSON { response in
      
      if let json = response.result.value as? NSDictionary {
        print("JSON: \(json)") // serialized json response
        
        // parse JSON, get bpi rates
        if let time = json["time"] as? [String:String] {
          if let updated = time["updated"] {
            if let bpiRates = json["bpi"] as? [String:Any] {
              if let rateInfos = bpiRates["EUR"] as? [String:Any] {
                print("rateInfo: \(rateInfos)")
                if let rate = rateInfos["rate_float"] as? Double {
                  Helper.currentDateAndRate = [updated:rate]
                  UserDefaults.standard.set([updated:rate], forKey: Helper.UserDefaultKeys.cachedLastRate)
                }
              }
            }
          }
        } else {
          print("wrong JSON parsing")
        }
      }
      
      if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
        print("Data: \(utf8Text)") // original server data as UTF8 string
      }
      group.leave()
    }
  }
  
  static func getCachedBpiResponse()->[String:Double]? {
    
    let defaults = UserDefaults.standard
    if let response = defaults.dictionary(forKey: Helper.UserDefaultKeys.cachedBpiResponse) as? [String:Double] {
      return response
    }
    return nil
  }
}

extension Date
{
  func toString( dateFormat format  : String ) -> String
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
  
  func daysBackFromNow(days: Int) -> Date {
    return Date(timeIntervalSinceNow: -60*60*24*Double.init(days))
  }
}
