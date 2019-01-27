//
//  BpiRowController.swift
//  Watch Extension
//
//  Created by skrr on 27.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import WatchKit

class BpiRowController: NSObject {

  @IBOutlet var dateLabel: WKInterfaceLabel!
  @IBOutlet var priceLabel: WKInterfaceLabel!

  var bpi:HistoricData? {
    didSet {
      guard let bpi = bpi else { return }
      
      dateLabel.setText(bpi.date)
      priceLabel.setText("\(bpi.price) EUR/BPI")
    }
  }
}
