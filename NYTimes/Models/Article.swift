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
    var abstract: String
    var media: [Media]
    var adxKeywords: String
}
