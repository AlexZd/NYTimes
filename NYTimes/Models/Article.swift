//
//  Article.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation

final class Article: Identifiable, Codable {
    var id: Int
    var title: String
    var url: URL
    var byline: String
    var publishedDate: Date
    var media: [Media]
}

#if DEBUG

extension Article {
    static func mock() -> Article {
        return try! Article(from: [
            "id": 100000007456461,
            "title": "Immunity to the Coronavirus May Last Years, New Data Hint",
            "url": "https://www.nytimes.com/2020/11/17/health/coronavirus-immunity.html",
            "byline": "By Apoorva Mandavilli",
            "published_date": "2020-11-17",
        ])
    }
}

#endif
