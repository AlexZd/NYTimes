//
//  NewsListViewModelTests.swift
//  NYTimesTests
//
//  Created by Alex on 19/11/2020.
//

import XCTest
import Combine
@testable import NYTimes

class NewsListViewModelTests: XCTestCase {
    private var validViewModel = NewsListViewModel<MockPopularNewsRepo>()
    private var invalidViewModel = NewsListViewModel<MockErrorPopularNewsRepo>()

    private var subscriptions = Set<AnyCancellable>()

    func testTitleLoading() {
        self.validViewModel.$title.first().sink { (title) in
            XCTAssertEqual(title, "Loading...")
        }.store(in: &self.subscriptions)
    }

    func testTitleSuccess() {
        self.validViewModel.$title.last().sink { (title) in
            XCTAssertEqual(title, "Popular News (10)")
        }.store(in: &self.subscriptions)
    }

    func testTitleInvalid() {
        self.invalidViewModel.$title.last().sink { (title) in
            XCTAssertEqual(title, "Error occured")
        }.store(in: &self.subscriptions)
    }

    func testSuccess() {
        self.validViewModel.$error.last().sink { (error) in
            XCTAssertNil(error)
        }.store(in: &self.subscriptions)

        self.validViewModel.$articles.last().sink { (articles) in
            XCTAssertFalse(articles.isEmpty)
        }.store(in: &self.subscriptions)
    }

    func testError() {
        self.invalidViewModel.$error.last().sink { (error) in
            XCTAssertNotNil(error)
        }.store(in: &self.subscriptions)

        self.invalidViewModel.$articles.last().sink { (articles) in
            XCTAssertTrue(articles.isEmpty)
        }.store(in: &self.subscriptions)
    }

    func testLoad() {
        self.validViewModel.$isLoading.sink { (isLoading) in
            XCTAssertTrue(isLoading)
        }.store(in: &self.subscriptions)

        self.validViewModel.daySelected(days: 7)
    }

    func testDaySelectedSameDay() {
        self.validViewModel.daySelected(days: 30)

        self.validViewModel.$isLoading.filter({ $0 == true }).dropFirst().sink { (_) in
            XCTFail("Same day should not perform refresh")
        }.store(in: &self.subscriptions)

        self.validViewModel.daySelected(days: 30)
    }

}
