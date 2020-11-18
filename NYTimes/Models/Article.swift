//
//  Article.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation

final class Article: Identifiable, Codable, Hashable {
    var id: Int
    var title: String
    var url: URL
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}

#if DEBUG

extension Article {
    static func mock() -> Article {
        return try! Article(from: [
            "id": 1,
            "title": "Article head title text",
            "url": "https://google.com",
        ])
    }
}

#endif
