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
    @Published private(set) var articles: [NewsItemViewModel] = []
    @Published private(set) var error: Error?
    @Published private(set) var days: Int = 1

    private var subscriptions = Set<AnyCancellable>()

    init() {
        self.setupBindings()
    }

    // MARK: - Setup

    private func setupBindings() {
        Publishers.CombineLatest3(self.$articles, self.$isLoading, self.$error).map({ (articles, isLoading, error) -> String in
            guard error == nil else { return "Error occured" }
            guard !isLoading else { return "Loading..." }
            return "Popular News (\(articles.count))"
        }).assignNoRetain(to: \.title, on: self).store(in: &self.subscriptions)

        self.$days.removeDuplicates().flatMap({ [weak self] (days) -> AnyPublisher<Result<PopularNewsResponse, Error>, Never> in
            self?.isLoading = true
            return Repo().index(days: days)
                .map({ .success($0) })
                .catch { Just(.failure($0)) }
                .eraseToAnyPublisher()
        }).sink(receiveValue: { [weak self] (result) in
            self?.isLoading = false
            switch result {
            case .success(let response):
                self?.articles = response.results.map({ NewsItemViewModel(with: $0) })
                self?.error = nil
            case .failure(let error):
                self?.error = error
            }
        }).store(in: &self.subscriptions)
    }

    // MARK: - Methods

    func daySelected(days: Int) {
        self.days = days
    }
}
