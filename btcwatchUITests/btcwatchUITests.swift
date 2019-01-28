//
//  btcwatchUITests.swift
//  btcwatchUITests
//
//  Created by skrr on 24.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import XCTest

class btcwatchUITests: XCTestCase {

  var app: XCUIApplication!
  
    override func setUp() {
        continueAfterFailure = false
      
        app = XCUIApplication()
      
        app.launch()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
  
  func testMainView() {
  
    // check if MainView is shown
    XCTAssertTrue(app.isDisplayingMainView)
    
    // check if current rate is there
    XCTAssertTrue(app.isCurrentRateShown)
    
    // check if currentRate was updated
    XCTAssertEqual(app.staticTexts["currentRate"].value as! String, "updated")
    
  }
  
  func testTableView() {
    // check if tableView is there
    XCTAssertTrue(app.isDisplayingMainView)
    
    // check if data for two weeks is there
    XCTAssertEqual(app.tables.cells.count,14)
  }
  
}

extension XCUIApplication {
  
  var isDisplayingMainView: Bool {
    return otherElements["mainView"].exists
  }
  var isDisplayingTableView: Bool {
    return otherElements["tableView"].exists
  }
  
  var isCurrentRateShown: Bool {
    return staticTexts["currentRate"].exists
  }
}
