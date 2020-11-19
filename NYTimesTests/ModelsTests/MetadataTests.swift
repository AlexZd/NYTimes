//
//  MetadataTests.swift
//  NYTimesTests
//
//  Created by Alex on 18/11/2020.
//

import XCTest
@testable import NYTimes

final class MetadataTests: XCTestCase {
    func testParseThumb() throws {
        let metadata = try Article.Media.Metadata(from: Article.Media.Metadata.Factory.JSON.thumb())
        XCTAssertEqual(metadata.url, URL(string: "https://static01.nyt.com/images/2020/11/04/us/politics/04TRUMP-ELECTION-1/04TRUMP-ELECTION-1-thumbStandard-v2.jpg"))
        XCTAssertEqual(metadata.format, .thumb)
        XCTAssertEqual(metadata.height, 75)
        XCTAssertEqual(metadata.width, 75)
    }
    
    func testParseMedium210() throws {
        let metadata = try Article.Media.Metadata(from: Article.Media.Metadata.Factory.JSON.medium210())
        XCTAssertEqual(metadata.url, URL(string: "https://static01.nyt.com/images/2020/11/16/opinion/16oster-01/16oster-01-mediumThreeByTwo210-v2.jpg"))
        XCTAssertEqual(metadata.format, .medium210)
        XCTAssertEqual(metadata.height, 140)
        XCTAssertEqual(metadata.width, 210)
    }
    
    func testParseMedium440() throws {
        let metadata = try Article.Media.Metadata(from: Article.Media.Metadata.Factory.JSON.medium440())
        XCTAssertEqual(metadata.url, URL(string: "https://static01.nyt.com/images/2020/11/16/opinion/16oster-01/16oster-01-mediumThreeByTwo440-v2.jpg"))
        XCTAssertEqual(metadata.format, .medium440)
        XCTAssertEqual(metadata.height, 293)
        XCTAssertEqual(metadata.width, 440)
    }
    
    

}
