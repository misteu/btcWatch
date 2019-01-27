//
//  Helper.swift
//  btcwatch
//
//  Created by skrr on 24.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit
import Alamofire


/// Helpers for requesting coindesk endpoints and transfering JSON responses to decoder
class RequestAndDecode {

  /// Requests coindesk endpoint, sorted data is available via BpiDataHistoric.sorted after successful response and decoding
  /// - Parameters:
  ///   - days: days back from now for requesting data
  ///   - group: DispatchGroup for async handling of Alamofire Request
  static func lastBpiPricesFor(days: Int, group: DispatchGroup) {
    
    let daysBack = Date().daysBackFromNow(days: days)
    let bpiHistoricRatesEndpoint = API.endpointForBpiRatesFrom(start: daysBack, toEnd: Date())
    
    Alamofire.request(bpiHistoricRatesEndpoint).responseJSON { response in
      
      if let data = response.data {
        
        // initialization makes shared prices available globally
        if BpiDataHistoric(jsonData: data).decoded != nil {
          // decoded data is accesible via shared static BpiDataHistoric.sorted
        }
      }
      group.leave()
    }
  }
  
  /// Requests coindesk endpoint, data is available via BpiData.shared after successful response and decoding
  /// - Parameters:
  ///   - group: DispatchGroup for async handling of Alamofire Request
  static func currentBpiEurPrice(group: DispatchGroup) {
    
    Alamofire.request(API.currentPriceEur).responseJSON { response in
      
      if let data = response.data {
        
        // initialization makes shared price available globally
        if BpiData(jsonData: data).decoded != nil {
          // decoded data is accesible via shared BpiData.shared
        }
      }
      group.leave()
    }
  }
  
}
