//
//  XMSwiftDemoUITests.swift
//  XMSwiftDemoUITests
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import XCTest

class XMSwiftDemoUITests: XCTestCase {
    
    var app:XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShowHistory() {
        app.navigationBars["XMSwiftDemo.View"].buttons["历史记录"].tap()
        let tableView = app.tables.firstMatch
        XCTAssertNotNil(tableView)
    }
    
    func testHistoryRefresh() {
        self.app.navigationBars["XMSwiftDemo.View"].buttons["历史记录"].tap()
        
        let tableView = self.app.tables.firstMatch
        XCTAssertNotNil(tableView)
        
        sleep(6)
        tableView.swipeDown()
        sleep(3)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
