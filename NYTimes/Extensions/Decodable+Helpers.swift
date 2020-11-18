//
//  Decodable+Helpers.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation

extension Decodable {
    init(from json: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try self.init(from: data)
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder.default.decode(Self.self, from: data)
    }
}
