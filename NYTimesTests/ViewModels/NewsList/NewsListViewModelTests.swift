//
//  NewsListViewModelTests.swift
//  NYTimesTests
//
//  Created by Alex on 19/11/2020.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking

@testable import NYTimes

class NewsListViewModelTests: XCTestCase {
    private var validViewModel = NewsListViewModel<MockPopularNewsRepo>()
    private var invalidViewModel = NewsListViewModel<MockErrorPopularNewsRepo>()

    private let disposeBag = DisposeBag()

    func testTitleLoading() {
        self.validViewModel.title.first().subscribe(onSuccess: { (title) in
            XCTAssertEqual(title, "Loading...")
        }).disposed(by: self.disposeBag)
    }

    func testTitleSuccess() {
        self.validViewModel.title.takeLast(1).subscribe(onNext: { (title) in
            XCTAssertEqual(title, "Popular News (10)")
        }).disposed(by: self.disposeBag)
    }

    func testTitleInvalid() {
        self.invalidViewModel.title.takeLast(1).subscribe(onNext: { (title) in
            XCTAssertEqual(title, "Error occured")
        }).disposed(by: self.disposeBag)
    }

    func testSuccess() {
        self.validViewModel.error.takeLast(1).subscribe(onNext: { (error) in
            XCTAssertNil(error)
        }).disposed(by: self.disposeBag)

        self.validViewModel.articles.takeLast(1).subscribe(onNext: { (articles) in
            XCTAssertFalse(articles.isEmpty)
        }).disposed(by: self.disposeBag)
    }

    func testError() {
        self.validViewModel.error.takeLast(1).subscribe(onNext: { (error) in
            XCTAssertNotNil(error)
        }).disposed(by: self.disposeBag)

        self.validViewModel.articles.takeLast(1).subscribe(onNext: { (articles) in
            XCTAssertTrue(articles.isEmpty)
        }).disposed(by: self.disposeBag)
    }

    func testLoad() {
        self.validViewModel.isLoading.subscribe(onNext: { (isLoading) in
            XCTAssertTrue(isLoading)
        }).disposed(by: self.disposeBag)

        self.validViewModel.daySelected(days: 7)
    }

    func testDaySelectedSameDay() {
        self.validViewModel.daySelected(days: 30)

        self.validViewModel.isLoading.filter({ $0 == true }).skip(1).subscribe(onNext: { (_) in
            XCTFail("Same day should not perform refresh")
        }).disposed(by: self.disposeBag)

        self.validViewModel.daySelected(days: 30)
    }

}
