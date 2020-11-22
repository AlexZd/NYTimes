//
//  PopularNewsRepo.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation
import Alamofire
import RxSwift

struct PopularNewsResponse: Decodable {
    let copyright: String
    let numResults: Int
    let results: [Article]
}

protocol PopularNewsRepo: Initiable {
    func index(days: Int) -> Single<PopularNewsResponse>
}

final class RemotePopularNewsRepo: PopularNewsRepo {
    func index(days: Int) -> Single<PopularNewsResponse> {
        return Single<PopularNewsResponse>.create { single in
            let url = ConfigurationManager.shared.configuration.baseUrl
                .appendingPathComponent("mostpopular/v2/viewed/\(days).json")
            let request = NY.request(url, method: .get, parameters: [:]).validateErrors().responseDecodable(decoder: JSONDecoder.default, completionHandler: { (response: DataResponse<PopularNewsResponse, AFError>) in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    single(.failure(error))
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

#if DEBUG

final class MockPopularNewsRepo: PopularNewsRepo {
    func index(days: Int) -> Single<PopularNewsResponse> {
        let results = 10
        let response = PopularNewsResponse(copyright: "Copyright MockPopularNewsRepo",
                                           numResults: results,
                                           results: Array(repeating: Article.Factory.Mock.mock(), count: results))
        return Single.just(response).delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    }
}

final class MockErrorPopularNewsRepo: PopularNewsRepo {
    func index(days: Int) -> Single<PopularNewsResponse> {
        //Seems `delay` does not work in case of error
        return Single.error(ResponseError.unknown.toError(code: 500)).delay(RxTimeInterval.seconds(10), scheduler: MainScheduler.instance)
    }
}

#endif
