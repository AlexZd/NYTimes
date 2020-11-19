//
//  ArticleViewModel.swift
//  NYTimes
//
//  Created by Alex on 19/11/2020.
//

import Foundation
import UIKit
import AlamofireImage
import Combine

final class ArticleViewModel: ObservableObject {
    @Published private(set) var isPhotoHidden: Bool = false
    @Published private(set) var photo: UIImage?
    @Published private(set) var date: String
    @Published private(set) var title: String
    @Published private(set) var subtitle: String
    @Published private(set) var text: String
    @Published private(set) var mediaCaption: String?
    @Published private(set) var keywords: String
    @Published private(set) var url: URL

    @Published private var photoUrl: URL?

    private var article: Article
    private var subscriptions = Set<AnyCancellable>()

    init(with article: Article) {
        self.title = article.title
        self.subtitle = article.byline
        self.text = article.abstract
        let media = article.media.first
        self.photoUrl = media?[.medium440]?.url
        self.mediaCaption = media?.caption
        self.url = article.url
        self.keywords = article.adxKeywords.components(separatedBy: ";").joined(separator: "; ")

        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        self.date = formatter.string(from: article.publishedDate)

        self.article = article

        self.setupBindings()
    }

    // MARK: - Setup

    private func setupBindings() {
        self.$photoUrl.map({ $0 == nil }).assignNoRetain(to: \.isPhotoHidden, on: self).store(in: &self.subscriptions)
        self.loadImage().assignNoRetain(to: \.photo, on: self).store(in: &self.subscriptions)
    }

    private func loadImage() -> AnyPublisher<UIImage?, Never> {
        return Future { [weak self] subscriber in
            guard let url = self?.photoUrl else {
                subscriber(.success(nil))
                return
            }
            let urlRequest = URLRequest(url: url)
            ImageDownloader.default.download(urlRequest, completion: { response in
                if let image = response.value {
                    subscriber(.success(image))
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
