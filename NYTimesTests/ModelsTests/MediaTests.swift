//
//  MediaTests.swift
//  NYTimesTests
//
//  Created by Alex on 18/11/2020.
//

import XCTest
@testable import NYTimes


final class MediaTests: XCTestCase {
    static var json: [String: Any] = [
        "media-metadata": [MetadataTests.jsonThumb, MetadataTests.jsonMedium210, MetadataTests.jsonMedium420]
    ]

    func testParse() throws {
        let media = try Article.Media(from: Self.json)
        XCTAssertEqual(media.metadata.count, 3)
    }

}
