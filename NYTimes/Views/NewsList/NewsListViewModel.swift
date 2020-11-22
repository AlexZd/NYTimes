//
//  NewsListViewModel.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

final class NewsListViewModel<Repo: PopularNewsRepo> {
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var title = BehaviorRelay<String?>(value: nil)
    private(set) var articles = BehaviorRelay<[NewsItemViewModel]>(value: [])
    private(set) var error = BehaviorRelay<Error?>(value: nil)
    private(set) var days = BehaviorRelay<Int>(value: 1)

    let indexTrigger = PublishRelay<Int>()

    private let disposeBag = DisposeBag()

    init() {
        self.setupBindings()
    }

    // MARK: - Setup

    private func setupBindings() {
        Observable.combineLatest(self.articles, self.isLoading, self.error).map { (articles, isLoading, error) -> String? in
            guard error == nil else { return "Error occured" }
            guard !isLoading else { return "Loading..." }
            return "Popular News (\(articles.count))"
        }.bind(to: self.title).disposed(by: self.disposeBag)

        self.indexTrigger.flatMap({ [weak self] (days) -> Single<Result<PopularNewsResponse, Error>> in
            self?.isLoading.accept(true)
            return Repo().index(days: days).map({ .success($0) }).catch({ Single.just(.failure($0)) })
        }).bind(onNext: { [weak self] (result) in
            self?.isLoading.accept(false)
            switch result {
            case .success(let response):
                self?.articles.accept(response.results.map({ NewsItemViewModel(with: $0) }))
                self?.error.accept(nil)
            case .failure(let error):
                self?.error.accept(error)
            }
        }).disposed(by: self.disposeBag)

        self.days.distinctUntilChanged().bind(to: self.indexTrigger).disposed(by: self.disposeBag)
    }

    // MARK: - Methods

    func daySelected(days: Int) {
        self.days.accept(days)
    }
}
