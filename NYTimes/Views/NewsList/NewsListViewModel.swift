//
//  NewsListViewModel.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation
import Combine

final class NewsListViewModel<Repo: PopularNewsRepo>: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var title: String?
    @Published private(set) var articles: [Article] = []
    @Published private(set) var error: Error?
    
    private let index = PassthroughSubject<Int, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.setupBindings()
    }
    
    //MARK: - Setup
    
    private func setupBindings() {
        Publishers.CombineLatest3(self.$articles, self.$isLoading, self.$error).map({ (articles, isLoading, error) -> String in
            guard error == nil else { return "Error occured" }
            guard !isLoading else { return "Loading..." }
            return "Popular News (\(articles.count))"
        }).assignNoRetain(to: \.title, on: self).store(in: &self.subscriptions)
        
        self.index.flatMap({ (days) -> AnyPublisher<Result<PopularNewsResponse, Error>, Never> in
            Repo().index(days: days).map({ .success($0) }).catch { Just(.failure($0)) }.eraseToAnyPublisher()
        }).sink(receiveValue: { [weak self] (result) in
            self?.isLoading = false
            switch result {
            case .success(let response):
                self?.articles = response.results
                self?.error = nil
            case .failure(let error):
                self?.error = error
            }
        }).store(in: &self.subscriptions)
    }
    
    //MARK: - Methods
    
    func load(days: Int = 1) {
        self.isLoading = true
        self.index.send(days)
    }
}
