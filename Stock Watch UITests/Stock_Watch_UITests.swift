//
//  Stock_Watch_UITests.swift
//  Stock Watch UITests
//
//  Created by DERMALOG on 06/03/2021.
//

import XCTest
import UIKit

class Stock_Watch_UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFirstScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["First"].tap()
        app.textFields.element.tap()
        app.textFields.element.typeText("IBM")
        app.buttons["search"].tap()
        app.wait(for: .unknown, timeout: 5)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSecondScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Second"].tap()
        let textField = app.textFields.element
        textField.tap()
        textField.typeText("IBM")
        let button = app.buttons["add"]
        button.tap()
        app.wait(for: .unknown, timeout: 3)
        textField.tap()
        textField.clearText()
        textField.typeText("AAPL")
        button.tap()
        app.wait(for: .unknown, timeout: 3)
        textField.tap()
        textField.clearText()
        textField.typeText("GOOG")
        button.tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        // workaround for apple bug
        if let placeholderString = self.placeholderValue, placeholderString == stringValue {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        typeText(deleteString)
    }
}
