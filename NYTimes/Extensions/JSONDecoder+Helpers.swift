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
        return decoder
    }()
}
