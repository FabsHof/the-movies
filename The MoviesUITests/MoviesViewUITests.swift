//
//  MoviesViewUITests.swift
//  The MoviesUITests
//
//  Created by Fabian Hofmann on 04.11.22.
//

import XCTest

final class MoviesViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }
    
    func testInitialPlaceholderText() throws {
        // Prepare
        let app = XCUIApplication()
        app.launch()
        
        // Execute
        let expectedText = "Start typing to search for movies!"
        let placeholderText = app.staticTexts[expectedText].firstMatch
        
        // Assert
        XCTAssertTrue(placeholderText.exists)
        XCTAssertTrue(placeholderText.isHittable)
    }

    func testTooShortSearchStringShowsPlaceholderText() throws {
        // Prepare
        let app = XCUIApplication()
        app.launch()
        
        let expectedText = "Continue typing to search for movies!"
        
        // Execute
        let textField = app.textFields.element
        textField.tap()
        textField.typeText("de")
        
        // Assert
        let textView = app.staticTexts[expectedText].firstMatch
        XCTAssertTrue(textView.exists)
        XCTAssertTrue(textView.isHittable)
    }
    
    func testEmptySearchStringShowsPlaceholderText() throws {
        // Prepare
        let app = XCUIApplication()
        app.launch()
        
        let expectedText = "Continue typing to search for movies!"
        let stringToType = "der"
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringToType.count)
        
        // Execute
        let textField = app.textFields.element
        textField.tap()
        textField.typeText(stringToType)
        textField.typeText(deleteString)
        
        // Assert
        let textView = app.staticTexts[expectedText].firstMatch
        XCTAssertTrue(textView.exists)
        XCTAssertTrue(textView.isHittable)
    }
    
    func testInvalidSearchStringShowsNoError() throws {
        // Prepare
        let app = XCUIApplication()
        app.launch()
        
        let stringToType = "ÄÖOPS"
        let expectedText = "0 results for \"ÄÖOPS\""
        
        // Execute
        let textField = app.textFields.element
        textField.tap()
        textField.typeText(stringToType)
        
        // Assume
        let textView = app.staticTexts[expectedText].firstMatch
        textView.waitForExistence(timeout: 5)
        XCTAssertTrue(textView.exists)
        XCTAssertTrue(textView.isHittable)
    }
    
    func testFittingSearchStringShowsResults() throws {
        // Prepare
        let app = XCUIApplication()
        app.launch()
        
        let stringToType = "der"
        let resultLabel = "resultStack"
        
        // Execute
        let textField = app.textFields.element
        textField.tap()
        textField.typeText(stringToType)
        
        let resultsView = app.collectionViews[resultLabel]
        resultsView.waitForExistence(timeout: 5)
        
        // Assert
        XCTAssert(resultsView.exists)
        XCTAssert(resultsView.isHittable)
    }

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
