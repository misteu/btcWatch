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
    
    checkForCachedDataAndUpdateUI()
    
    // do async requests
    requestCurrentRateAndUpdateUI()
    requestHistoricRatesAndUpdateUI(daysBackFromNow: 14)
    
    Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.requestCurrentRateAndUpdateUI), userInfo: nil, repeats: true)
    
  }
  
  @objc func requestCurrentRateAndUpdateUI() {
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue.main.async {
      Helper.requestCurrentBpiEurRate(group: group)
    }
    
    group.notify(queue: .main) {
      print("ready")
      
      if let dateAndRate = Helper.currentDateAndRate.popFirst() {
        self.currentRate.text = "Minutengenauer Kurs:\n\(dateAndRate.key)\n \(dateAndRate.value) EUR/BTC"
      }
    }
  }
  
  func requestHistoricRatesAndUpdateUI(daysBackFromNow: Int) {
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue.main.async {
      Helper.requestLastBpiRatesFor(days: daysBackFromNow, group: group)
    }
    
    group.notify(queue: .main) {
      print("ready")
      
      print(Helper.newestBpiData)
      self.tableView.reloadData()
    }
  }
  
  func checkForCachedDataAndUpdateUI() {
    
    // load old rate data if there
    if let cachedBpiData = Helper.getCachedBpiResponse() {
      Helper.newestBpiData = cachedBpiData.sorted(by: { $0.key > $1.key })
      self.tableView.reloadData()
    }
    
    // get cached Rate if there
    if let cachedRateDict = UserDefaults.standard.dictionary(forKey: Helper.UserDefaultKeys.cachedLastRate) {
      var cached = cachedRateDict
      if let cachedRate = cached.popFirst() {
        self.currentRate.text = "Minutengenauer Kurs:\n\(cachedRate.key)\n \(cachedRate.value) EUR/BTC"
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      if Helper.newestBpiData.count > 0 {
        return Helper.newestBpiData.count
      }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: Helper.bpiRateCell) as? BtcRateTableViewCell {
      
      let bpiData = Helper.newestBpiData
      if bpiData.count > 0 {
        
          let date = bpiData[indexPath.item].0
          let rate = bpiData[indexPath.item].1
          
          cell.date.text = date
          cell.exchangeRate.text = "\(rate) EUR/BTC"
        
      }
      
      return cell
    }
    return UITableViewCell.init()
  }
  
}

