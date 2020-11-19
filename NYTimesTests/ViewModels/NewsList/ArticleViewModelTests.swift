//
//  ArticleViewModelTests.swift
//  NYTimesTests
//
//  Created by Alex on 19/11/2020.
//

import XCTest
@testable import NYTimes

class ArticleViewModelTests: XCTestCase {

    func testValues() {
        let viewModel = ArticleViewModel(with: Article.Factory.Mock.mock())
        XCTAssertEqual(viewModel.title, "Immunity to the Coronavirus May Last Years, New Data Hint")
        XCTAssertEqual(viewModel.subtitle, "By Apoorva Mandavilli")
        XCTAssertEqual(viewModel.date, "November 17, 2020")
        XCTAssertEqual(viewModel.text, "Joseph R. Biden Jr. achieved victory offering a message of healing and unity. He will return to Washington facing a daunting set of crises.")
        XCTAssertEqual(viewModel.mediaCaption, "Blood was drawn for a Covid-19 antibody test at the University of Arizona in Tucson earlier this year.")
        XCTAssertEqual(viewModel.url, URL(string: "https://www.nytimes.com/2020/11/17/health/coronavirus-immunity.html"))
        XCTAssertEqual(viewModel.keywords, "Immune System; Coronavirus (2019-nCoV); Antibodies; Vaccination and Immunization; SARS (Severe Acute Respiratory Syndrome); your-feed-science; La Jolla (Calif)")
        XCTAssertFalse(viewModel.isPhotoHidden)
    }
    
    func testEmptyMedia() {
        let article = Article.Factory.Mock.mock()
        article.media = []
        let viewModel = ArticleViewModel(with: article)
        XCTAssertTrue(viewModel.isPhotoHidden)
    }

}
