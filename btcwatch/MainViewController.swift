//
//  ViewController.swift
//  btcwatch
//
//  Created by skrr on 24.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var currentRate: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // for UI-Testing
    view.accessibilityIdentifier = "mainView"
    tableView.accessibilityIdentifier = "tableView"
    currentRate.accessibilityIdentifier = "currentRate"
    
    checkForCachedDataAndUpdateUI()
    
    requestCurrentPriceAndUpdateUI()
    requestHistoricRatesAndUpdateUI(daysBackFromNow: 14)
    
    // refresh current price, coindesk has max. one new price per minute
    Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.requestCurrentPriceAndUpdateUI), userInfo: nil, repeats: true)
  }
  
  /// update UI after request to coindesk-API and JSON decoding with current bpi price
  @objc func requestCurrentPriceAndUpdateUI() {
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue.main.async {
      RequestAndDecode.currentBpiEurPrice(group: group)
    }
    
    group.notify(queue: .main) {
      
      //use decoded Json response for UI updates
      if let bpi = BpiData.shared {
        self.currentRate.text = "Minutengenauer Kurs:\n\(bpi.time.updated)\n \(bpi.exchangeRate.eur.rate) EUR/BTC"
        
        // for UI-Testing
        self.currentRate.accessibilityValue = "updated"
      }
    }
  }
  
  /// update UI after request to coindesk-API and JSON decoding with historic bpi data
  func requestHistoricRatesAndUpdateUI(daysBackFromNow: Int) {
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue.main.async {
      RequestAndDecode.lastBpiPricesFor(days: daysBackFromNow, group: group)
    }
    
    group.notify(queue: .main) {
      self.tableView.reloadData()
    }
  }
  
  /// trys to decode cached JSON (in shared UserDefaults), updates UI if successful
  func checkForCachedDataAndUpdateUI() {
    
    // init retrieves cached data (if available) and decodes it globally accessible
    if BpiDataHistoric().decoded != nil {
      self.tableView.reloadData()
    }
    
    if let cached = BpiData().decoded {
      self.currentRate.text = "Minutengenauer Kurs:\n\(cached.time.updated)\n \(cached.exchangeRate.eur.rate) EUR/BTC"
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if let bpiRates = BpiDataHistoric.sorted, bpiRates.count > 0{
      return bpiRates.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BtcRateTableViewCell {
      
      if let bpiRates = BpiDataHistoric.sorted, bpiRates.count > 0{
        
        cell.date.text = bpiRates[indexPath.item].0
        cell.exchangeRate.text = "\(bpiRates[indexPath.item].1) EUR/BPI"
        
        // for UI-Testing
        cell.isAccessibilityElement = true
        
      }
      return cell
    }
    return UITableViewCell.init()
  }
}
