//
//  PopularNewsRepo.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation
import Alamofire
import Combine

struct PopularNewsResponse: Decodable {
    let copyright: String
    let numResults: Int
    let results: [Article]
}

protocol PopularNewsRepo: Initiable {
    func index(days: Int) -> AnyPublisher<PopularNewsResponse, Error>
}

final class RemotePopularNewsRepo: PopularNewsRepo {
    func index(days: Int) -> AnyPublisher<PopularNewsResponse, Error> {
        let url = ConfigurationManager.shared.configuration.baseUrl
            .appendingPathComponent("mostpopular/v2/viewed/\(days).json")
        return NY.request(url, method: .get, parameters: [:]).validateErrors()
            .publishDecodable(type: PopularNewsResponse.self, decoder: JSONDecoder.default)
            .tryCompactMap { (response) -> PopularNewsResponse? in
                if let error = response.error { throw error }
                return response.value
            }
            .eraseToAnyPublisher()
    }
}

final class MockPopularNewsRepo: PopularNewsRepo {
    func index(days: Int) -> AnyPublisher<PopularNewsResponse, Error> {
        let results = 10
        let response = PopularNewsResponse(copyright: "Copyright MockPopularNewsRepo",
                                           numResults: results,
                                           results: Array(repeating: Article.mock(), count: results))
        return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

final class MockErrorPopularNewsRepo: PopularNewsRepo {
    func index(days: Int) -> AnyPublisher<PopularNewsResponse, Error> {
        return Just(()).tryMap({ throw ResponseError.unknown.toError(code: 500) }).eraseToAnyPublisher()
    }
}
