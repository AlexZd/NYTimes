//
//  ArticleTests.swift
//  NYTimesTests
//
//  Created by Alex on 18/11/2020.
//

import XCTest
@testable import NYTimes

class ArticleTests: XCTestCase {
    func testParse() throws {
        let article = try Article(from: Article.Factory.JSON.json())
        XCTAssertEqual(article.id, 100000007456461)
        XCTAssertEqual(article.title, "Immunity to the Coronavirus May Last Years, New Data Hint")
        XCTAssertEqual(article.url, URL(string: "https://www.nytimes.com/2020/11/17/health/coronavirus-immunity.html"))
        XCTAssertEqual(article.byline, "By Apoorva Mandavilli")
        XCTAssertEqual(article.publishedDate, DateComponents(calendar: Calendar.current, year: 2020, month: 11, day: 17).date)
        XCTAssertEqual(article.media.count, 1)
        XCTAssertEqual(article.abstract, "Joseph R. Biden Jr. achieved victory offering a message of healing and unity. He will return to Washington facing a daunting set of crises.")
        XCTAssertEqual(article.adxKeywords, "Immune System;Coronavirus (2019-nCoV);Antibodies;Vaccination and Immunization;SARS (Severe Acute Respiratory Syndrome);your-feed-science;La Jolla (Calif)")
    }

}
