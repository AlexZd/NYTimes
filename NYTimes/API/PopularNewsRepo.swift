//
//  PopularNewsRepo.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation
import Combine

protocol PopularNewsRepo: Initiable {
    func index(params: [String: Any])
}

final class RemotePopularNewsRepo: PopularNewsRepo {
    func index(params: [String: Any]) {
    }
}

#if DEBUG

final class MockPopularNewsRepo: PopularNewsRepo {
    func index(params: [String: Any]) {
    }
}

#endif
