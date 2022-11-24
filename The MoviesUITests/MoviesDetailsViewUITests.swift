//
//  MoviesDetailsViewUITests.swift
//  The MoviesUITests
//
//  Created by Fabian Hofmann on 04.11.22.
//

import XCTest

final class MoviesDetailsViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testOpenDetailsPage() throws {
        // Prepare
        let app = XCUIApplication()
        app.launch()
        
        let stringToType = "der"
        let resultLabel = "resultStack"
        let movieLabel = "Der Schuh des Manitu"
        let plotLabel = "Plot"
        
        // Execute
        let textField = app.textFields.element
        textField.tap()
        textField.typeText(stringToType)
        
        let resultsView = app.collectionViews[resultLabel]
        resultsView.waitForExistence(timeout: 5)
        
        let movieTitle = app.staticTexts[movieLabel]
        movieTitle.waitForExistence(timeout: 5)
        movieTitle.tap()
        
        // Assert
        let plotTextView = app.staticTexts[plotLabel]
        plotTextView.waitForExistence(timeout: 5)
        
        XCTAssert(plotTextView.exists)
        XCTAssert(plotTextView.isHittable)
    }
}
