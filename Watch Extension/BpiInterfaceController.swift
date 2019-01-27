//
//  BpiInterfaceController.swift
//  Watch Extension
//
//  Created by skrr on 27.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import WatchKit
import Foundation


class BpiInterfaceController: WKInterfaceController {
  
  @IBOutlet weak var bpiTable: WKInterfaceTable!
  @IBOutlet weak var bpiCurrentPriceLabel: WKInterfaceLabel!
  @IBOutlet weak var bpiCurrentPriceDateLabel: WKInterfaceLabel!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    checkForCachedDataAndUpdateUI()
    requestAndUpdateWithNewData()
    
    // endpoint has max one new price per minute
    Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.requestAndUpdateWithNewData), userInfo: nil, repeats: true)
  }
  
  func updateWatchUi(sortedData: SortedHistoricData, currentPriceData:BpiData.CurrentBpiRate) {
    
    self.bpiCurrentPriceDateLabel.setText(currentPriceData.time.updated)
    self.bpiCurrentPriceLabel.setText("\(currentPriceData.exchangeRate.eur.rate) EUR/BPI")
    
    self.bpiTable.setNumberOfRows(sortedData.count, withRowType: "BpiRow")
    
    for index in 0..<self.bpiTable.numberOfRows {
      guard let controller = self.bpiTable.rowController(at: index) as? BpiRowController else { continue }
      controller.bpi = sortedData[index]
      
    }
  }
  
  func checkForCachedDataAndUpdateUI() {
    
    // init retrieves cached data (if available) and decodes it globally accessible
    if BpiDataHistoric().decoded != nil && BpiData().decoded != nil {
      
      print("cached historic: \(String(describing: BpiDataHistoric.sorted)) cached currentPrice: \(String(describing: BpiData.shared))" )
      
      if let cachedHistoricData = BpiDataHistoric.sorted, let cachedCurrentPrice = BpiData.shared {
        self.updateWatchUi(sortedData: cachedHistoricData, currentPriceData: cachedCurrentPrice)
      }
    }
  }
  
  func requestNewData(group: DispatchGroup) {
    
    group.enter()
    DispatchQueue.main.async {
      RequestAndDecode.lastBpiPricesFor(days: 14, group: group)
    }
    
    group.enter()
    DispatchQueue.main.async {
      RequestAndDecode.currentBpiEurPrice(group: group)
    }
  }
  
  @objc func requestAndUpdateWithNewData() {
    let group = DispatchGroup()
    
    requestNewData(group: group)
    
    group.notify(queue: .main) {
      if let sortedData = BpiDataHistoric.sorted, let currentPriceData = BpiData.shared {
        self.updateWatchUi(sortedData: sortedData, currentPriceData: currentPriceData)
      }
    }
  }
  
}
