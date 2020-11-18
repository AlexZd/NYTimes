//
//  Request+Helpers.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation
import Alamofire

let NY = Session(interceptor: NYAdapter())

private class NYAdapter: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let params: Parameters = ["api-key": ConfigurationManager.shared.configuration.apiKey]
        guard let newRequest = try? URLEncoding.queryString.encode(urlRequest, with: params) else {
            completion(.success(urlRequest))
            return
        }
        completion(.success(newRequest))
    }
}

///For production instead of `print` function we will use some logger, which will print only in debug builds
public extension Alamofire.DataRequest {
    @discardableResult
    func validateErrors() -> Alamofire.DataRequest {
        return self.validate { (request, response, data) -> Alamofire.Request.ValidationResult in
            let code = response.statusCode
            let requestURL = String(describing: request?.url?.absoluteString ?? "NO URL")
            guard let data = data, let string = String(data: data, encoding: .utf8) else {
                print(String(code) + " " + requestURL + "\nEmpty response")
                return .success(())
            }
            if code >= 400 && code < 500 {
                let responseError = try? ResponseError(from: data)
                let error = responseError?.toError(code: code) ?? ResponseError.unknown.toError(code: code)
                print(String(code) + " " + requestURL + "\n\(error)\n\(string)")
                return .failure(error)
            } else {
                print(String(code) + " " + requestURL + "\n\(string)")
            }
            return .success(())
        }
    }
}
