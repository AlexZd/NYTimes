//
//  ConfigurationManager.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation
import Alamofire

final class ConfigurationManager {
    public enum Configuration {
        case development
        
        var baseUrl: URL {
            switch self {
            case .development:
                return URL(string: "https://api.nytimes.com/svc/")!
            }
        }
        
        var apiKey: String {
            switch self {
            case .development:
                return "pcLav4wzPkXzMbhk4ACrqz6vLLZTsmS5"
            }
        }
    }
    
    static private(set) var shared: ConfigurationManager!
    
    var configuration: Configuration
    
    static func initialize(with configuration: Configuration) {
        Self.shared = Self.init(with: configuration)
    }
    
    private init(with configuration: Configuration) {
        self.configuration = configuration
    }
}
