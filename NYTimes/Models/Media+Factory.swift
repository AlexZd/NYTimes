//
//  Media+Factory.swift
//  NYTimes
//
//  Created by Alex on 19/11/2020.
//

#if DEBUG

import Foundation

extension Article.Media.Metadata {
    enum Factory {
        enum JSON {
            static func thumb() -> [String: Any] {
                return [
                    "url":"https://static01.nyt.com/images/2020/11/04/us/politics/04TRUMP-ELECTION-1/04TRUMP-ELECTION-1-thumbStandard-v2.jpg",
                    "format":"Standard Thumbnail",
                    "height":75,
                    "width":75
                ]
            }
            
            static func medium210() -> [String: Any] {
                return [
                    "url":"https://static01.nyt.com/images/2020/11/16/opinion/16oster-01/16oster-01-mediumThreeByTwo210-v2.jpg",
                    "format":"mediumThreeByTwo210",
                    "height":140,
                    "width":210
                ]
            }
            
            static func medium440() -> [String: Any] {
                return [
                    "url":"https://static01.nyt.com/images/2020/11/16/opinion/16oster-01/16oster-01-mediumThreeByTwo440-v2.jpg",
                    "format":"mediumThreeByTwo440",
                    "height":293,
                    "width":440
                ]
            }
        }
        
        enum Mock {
            static func mock() -> Article.Media.Metadata {
                return try! Article.Media.Metadata(from: Article.Media.Metadata.Factory.JSON.thumb())
            }
        }
    }
}

extension Article.Media {
    enum Factory {
        enum JSON {
            static func json() -> [String: Any] {
                return [
                    "caption": "Blood was drawn for a Covid-19 antibody test at the University of Arizona in Tucson earlier this year.",
                    "media-metadata": [
                        Metadata.Factory.JSON.thumb(),
                        Metadata.Factory.JSON.medium210(),
                        Metadata.Factory.JSON.medium440()
                    ]
                ]
            }
        }
        
        enum Mock {
            static func mock() -> Article.Media {
                return try! Article.Media(from: Article.Media.Factory.JSON.json())
            }
        }
    }
}

#endif
