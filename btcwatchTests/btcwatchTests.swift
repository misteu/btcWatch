//
//  btcwatchTests.swift
//  btcwatchTests
//
//  Created by skrr on 24.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import XCTest
@testable import btcwatch

class btcwatchTests: XCTestCase {
  
  override func setUp() {
    
    // delete any cached data
    BpiDataHistoric.sorted = nil
    BpiData.shared = nil
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testDateToStringExtension() {
    
    //test only for yyyy-MM-dd format needed for API-Endpoint
    
    // test with reference date
    XCTAssertEqual(Date(timeIntervalSinceReferenceDate: 0).toString(dateFormat: "yyyy-MM-dd"), "2001-01-01")
    
    // test with 1970
    XCTAssertEqual(Date(timeIntervalSince1970: 0).toString(dateFormat: "yyyy-MM-dd"), "1970-01-01")
    
    // test with two days after reference date
    XCTAssertEqual(Date(timeIntervalSinceReferenceDate: 60*60*24*2).toString(dateFormat: "yyyy-MM-dd"), "2001-01-03")
    
    // test with two days before reference date
    XCTAssertEqual(Date(timeIntervalSinceReferenceDate: -60*60*24*2).toString(dateFormat: "yyyy-MM-dd"), "2000-12-30")
    
  }
  
  
  func testDateDaysBackFromNowExtension() {
    
    // test for today
    XCTAssertEqual(Date().toString(dateFormat: "yyyy-MM-dd"), Date().daysBackFromNow(days: 0).toString(dateFormat: "yyyy-MM-dd"))
    
    // test for 14 days back from now
    let twoWeeksBackInSeconds = -60.0*60*24*14
    XCTAssertEqual(Date(timeIntervalSinceNow: twoWeeksBackInSeconds).toString(dateFormat: "yyyy-MM-dd"), Date().daysBackFromNow(days: 14).toString(dateFormat: "yyyy-MM-dd"))
    
  }
  
  func testApiEndPointForHistoricalBpiRatesFromTodayTo() {
    
    // test from today 14 days back
    let today = Date().toString(dateFormat: "yyyy-MM-dd")
    let fourteenDaysBack = Date().daysBackFromNow(days: 14)
    let fourteenDaysBackStr = fourteenDaysBack.toString(dateFormat: "yyyy-MM-dd")
    
    XCTAssertEqual("https://api.coindesk.com/v1/bpi/historical/close.json?start=\(fourteenDaysBackStr)&end=\(today)", API.endpointForBpiRatesFrom(start: fourteenDaysBack, toEnd: Date()))
  }
  
  func readJSONFromFile(fileName: String) -> Data?
  {
    var data: Data?
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
      do {
        let fileUrl = URL(fileURLWithPath: path)
        // Getting data from JSON file using the file URL
        data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
      } catch {
        // Handle error here
      }
    }
    return data
  }
  
  func testJSONRequestWithBpi() {
    
    if let testJsonBpi = readJSONFromFile(fileName: "testJsonBpi") {
      _ = BpiData.init(jsonData: testJsonBpi)
      
      XCTAssertEqual(BpiData.shared?.exchangeRate.eur.rate, 3126.0874)
      XCTAssertEqual(BpiData.shared?.time.updated, "Jan 27, 2019 21:36:00 UTC")
      
    } else {
      XCTFail("error reading testJSON")
    }
  }
  
  func testJSONRequestWithBpiHistoric() {
    
    if let testJsonBpi = readJSONFromFile(fileName: "testJsonBpiHistoric") {
      _ = BpiDataHistoric.init(jsonData: testJsonBpi)
      
      XCTAssertEqual(BpiDataHistoric.sorted?.count, 14)
      XCTAssertEqual(BpiDataHistoric.sorted?[3].0, "2018-01-22")
      XCTAssertEqual(BpiDataHistoric.sorted?[3].1, 10772.15)
      
    } else {
      XCTFail("error reading testJSON")
    }
  }
  
}
