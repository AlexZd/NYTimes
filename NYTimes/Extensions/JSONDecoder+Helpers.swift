//
//  JSONDecoder+Helpers.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation

extension JSONDecoder {
    static var `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            var date: Date?
            if let d = formatter.date(from: dateStr) {
                date = d
            }

            guard let d = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
            }
            return d
        })
        return decoder
    }()
}
