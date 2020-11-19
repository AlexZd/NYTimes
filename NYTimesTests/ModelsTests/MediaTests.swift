//
//  MediaTests.swift
//  NYTimesTests
//
//  Created by Alex on 18/11/2020.
//

import XCTest
@testable import NYTimes

class MediaTests: XCTestCase {

    func testDecoding() throws {
        let media = try Article.Media(from: Article.Media.Factory.JSON.json())
        XCTAssertEqual(media.metadata.count, 3)
        XCTAssertEqual(media.caption, "Blood was drawn for a Covid-19 antibody test at the University of Arizona in Tucson earlier this year.")
    }

    func testSubscript() {
        let media = Article.Media.Factory.Mock.mock()
        XCTAssertEqual(media[.medium210]?.url.absoluteString, "https://static01.nyt.com/images/2020/11/16/opinion/16oster-01/16oster-01-mediumThreeByTwo210-v2.jpg")
    }

}
