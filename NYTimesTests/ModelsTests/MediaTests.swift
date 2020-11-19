//
//  MediaTests.swift
//  NYTimesTests
//
//  Created by Alex on 18/11/2020.
//

import XCTest
@testable import NYTimes


class MediaTests: XCTestCase {
    
    func testParse() throws {
        let media = try Article.Media(from: Article.Media.Factory.JSON.json())
        XCTAssertEqual(media.metadata.count, 3)
    }
    
}
