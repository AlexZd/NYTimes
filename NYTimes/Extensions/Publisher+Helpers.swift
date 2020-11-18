//
//  Publisher+Helpers.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Combine

extension Publisher where Failure == Never {
    func assignNoRetain<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
