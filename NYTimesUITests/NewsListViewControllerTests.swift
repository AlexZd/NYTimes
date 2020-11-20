//
//  NYTimesUITests.swift
//  NYTimesUITests
//
//  Created by Alex on 18/11/2020.
//

import XCTest

class NYTimesUITests: XCTestCase {

    override func setUpWithError() throws {
        self.continueAfterFailure = false
    }

    func testError() {
        let app = XCUIApplication()
        app.launchArguments = ["error-testing"]
        app.launch()

        XCTAssertTrue(app.navigationBars.staticTexts["Error occured"].exists)
        XCTAssertTrue(app.staticTexts["Unknown error :("].exists)
        XCTAssertFalse(app.tables.element.isHittable)
    }

    func testSuccess() {
        let app = XCUIApplication()
        app.launchArguments = ["success-testing"]
        app.launch()

        //Checking table
        XCTAssertTrue(app.navigationBars.staticTexts["Popular News (10)"].exists)
        XCTAssertTrue(app.tables.element.isHittable)
        XCTAssertEqual(app.tables.element.cells.count, 10)

        app.tables.cells.firstMatch.swipeUp()
        app.tables.cells.allElementsBoundByIndex.last?.swipeDown()

        //Checking action sheet
        app.navigationBars.element.buttons["Search"].tap()
        XCTAssertEqual(app.sheets.element.buttons.allElementsBoundByIndex.map({ $0.label }), ["✓ 1 day", "7 days", "30 days", "Cancel"])
        app.sheets.buttons["7 days"].tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Loading..."].exists)

        app.navigationBars.element.buttons["Search"].tap()
        XCTAssertEqual(app.sheets.element.buttons.allElementsBoundByIndex.map({ $0.label }), ["1 day", "✓ 7 days", "30 days", "Cancel"])
        app.sheets.buttons["Cancel"].tap()

        //Checking cell
        let cell = app.tables.cells.firstMatch
        XCTAssertEqual(cell.staticTexts["title"].label, "Immunity to the Coronavirus May Last Years, New Data Hint")
        XCTAssertEqual(cell.staticTexts["subtitle"].label, "By Apoorva Mandavilli")
        XCTAssertEqual(cell.staticTexts["date"].label, "Nov 17, 2020")
    }

}
