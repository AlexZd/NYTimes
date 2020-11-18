//
//  Media.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation

extension Article {
    final class Media: Codable {
        final class Metadata: Codable {
            var url: URL
            var format: Format
            var height: Int
            var width: Int
            
            enum Format: String, Codable {
                case thumb = "Standard Thumbnail"
                case medium210 = "mediumThreeByTwo210"
                case medium440 = "mediumThreeByTwo440"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case metadata = "media-metadata"
        }
        
        var metadata: [Metadata]
        
        subscript(key: Metadata.Format) -> Metadata? {
            self.metadata.first(where: { $0.format == key })
        }
    }
}
