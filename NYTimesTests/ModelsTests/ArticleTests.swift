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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        XCTAssertEqual(article.publishedDate, formatter.date(from: "2020-11-17"))
        
        XCTAssertEqual(article.media.count, 1)
    }

}
