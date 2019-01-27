//
//  Extensions.swift
//  btcwatch
//
//  Created by skrr on 26.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit
import WatchKit


extension Date
{
  
  /// converts Date object to String with given date formatter string
  
  /// - Parameters:
  ///   - format: e.g. "yyyy-MM-dd" for "2019-01-01"
  func toString( dateFormat format  : String ) -> String
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
  
  /// returns a Date object that is x days before today
  func daysBackFromNow(days: Int) -> Date {
    let daysInSeconds = -60.0*60*24
    return Date(timeIntervalSinceNow: daysInSeconds*Double(days))
  }
}
