//
//  ResponseError.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation

struct ResponseError: Codable {
    var fault: Fault
    
    struct Fault: Codable {
        var faultstring: String
    }
    
    func toError(code: Int) -> Error {
        let info = [NSLocalizedDescriptionKey: fault.faultstring]
        return NSError(domain: "com.alex.NYTimes", code: code, userInfo: info)
    }
    
    static var unknown = ResponseError(fault: Fault(faultstring: "Unknown error :("))
}
