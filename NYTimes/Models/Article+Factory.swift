//
//  Article+Factory.swift
//  NYTimes
//
//  Created by Alex on 19/11/2020.
//

#if DEBUG

import Foundation

extension Article {
    enum Factory {
        enum JSON {
            static func json() -> [String: Any] {
                return [
                    "id": 100000007456461,
                    "title": "Immunity to the Coronavirus May Last Years, New Data Hint",
                    "url": "https://www.nytimes.com/2020/11/17/health/coronavirus-immunity.html",
                    "byline": "By Apoorva Mandavilli",
                    "published_date": "2020-11-17",
                    "abstract": "Joseph R. Biden Jr. achieved victory offering a message of healing and unity. He will return to Washington facing a daunting set of crises.",
                    "adx_keywords": "Immune System;Coronavirus (2019-nCoV);Antibodies;Vaccination and Immunization;SARS (Severe Acute Respiratory Syndrome);your-feed-science;La Jolla (Calif)",
                    "media": [Media.Factory.JSON.json()]
                ]
            }
        }

        enum Mock {
            static func mock() -> Article {
                return try! Article(from: Article.Factory.JSON.json())
            }
        }
    }
}

#endif
