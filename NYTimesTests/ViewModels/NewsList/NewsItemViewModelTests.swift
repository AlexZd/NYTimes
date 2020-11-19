//
//  NewsItemViewModelTests.swift
//  NYTimesTests
//
//  Created by Alex on 19/11/2020.
//

import XCTest
@testable import NYTimes

class NewsItemViewModelTests: XCTestCase {

    func testEquatable() {
        let viewModel1 = NewsItemViewModel(with: Article.Factory.Mock.mock())

        let article = Article.Factory.Mock.mock()
        article.id = 0
        let viewModel2 = NewsItemViewModel(with: article)

        XCTAssertFalse(viewModel1 == viewModel2)
    }

    func testValues() {
        let viewModel = NewsItemViewModel(with: Article.Factory.Mock.mock())
        XCTAssertEqual(viewModel.title, "Immunity to the Coronavirus May Last Years, New Data Hint")
        XCTAssertEqual(viewModel.subtitle, "By Apoorva Mandavilli")
        XCTAssertEqual(viewModel.date, "Nov 17, 2020")
        XCTAssertEqual(viewModel.thumbUrl, URL(string: "https://static01.nyt.com/images/2020/11/04/us/politics/04TRUMP-ELECTION-1/04TRUMP-ELECTION-1-thumbStandard-v2.jpg"))
        XCTAssertFalse(viewModel.isThumbHidden)
    }

    func testEmptyMedia() {
        let article = Article.Factory.Mock.mock()
        article.media = []
        let viewModel = NewsItemViewModel(with: article)
        XCTAssertNil(viewModel.thumbUrl)
        XCTAssertTrue(viewModel.isThumbHidden)
    }

}
