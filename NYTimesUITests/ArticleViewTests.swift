//
//  ArticleViewTests.swift
//  NYTimesUITests
//
//  Created by Alex on 20/11/2020.
//

import XCTest

class ArticleViewTests: XCTestCase {

    override func setUpWithError() throws {
        self.continueAfterFailure = false
    }

    func testArticle() {
        let app = XCUIApplication()
        app.launchArguments = ["success-testing"]
        app.launch()

        app.tables.cells.firstMatch.tap()

        XCTAssertTrue(app.navigationBars.staticTexts["Details"].exists)

        let image = app.scrollViews.images.element
        XCTAssertTrue(image.isHittable)
        let realRatio = image.frame.width / image.frame.height
        let expectedRation: CGFloat = 3 / 2
        XCTAssertTrue(abs(realRatio - expectedRation) <= CGFloat.ulpOfOne)

        XCTAssertEqual(app.scrollViews.staticTexts["mediaCaption"].label, "Blood was drawn for a Covid-19 antibody test at the University of Arizona in Tucson earlier this year.")
        XCTAssertEqual(app.scrollViews.staticTexts["date"].label, "November 17, 2020")
        XCTAssertEqual(app.scrollViews.staticTexts["title"].label, "Immunity to the Coronavirus May Last Years, New Data Hint")
        XCTAssertEqual(app.scrollViews.staticTexts["subtitle"].label, "By Apoorva Mandavilli")
        XCTAssertEqual(app.scrollViews.staticTexts["text"].label, "Joseph R. Biden Jr. achieved victory offering a message of healing and unity. He will return to Washington facing a daunting set of crises.")
        XCTAssertEqual(app.scrollViews.staticTexts["keywords"].label, "Immune System; Coronavirus (2019-nCoV); Antibodies; Vaccination and Immunization; SARS (Severe Acute Respiratory Syndrome); your-feed-science; La Jolla (Calif)")

        XCTAssertFalse(app.webViews.element.exists)
        app.buttons["readMore"].tap()
        XCTAssertTrue(app.webViews.element.exists)
    }

}
