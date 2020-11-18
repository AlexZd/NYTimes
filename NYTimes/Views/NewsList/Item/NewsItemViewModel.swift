//
//  NewsItemViewModel.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import Foundation
import AlamofireImage

final class NewsItemViewModel: ObservableObject, Hashable {
    @Published private(set) var title: String
    @Published private(set) var subtitle: String
    @Published private(set) var date: String
    @Published private(set) var thumbUrl: URL?
    @Published private(set) var thumbHidden: Bool
    
    private var article: Article
    
    //MARK: - Lifecycle
    
    init(with article: Article) {
        self.title = article.title
        self.subtitle = article.byline
        
        let media = article.media.first
        let thumbUrl = media?[.thumb]?.url
        self.thumbUrl = thumbUrl
        self.thumbHidden = thumbUrl == nil
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.date = formatter.string(from: article.publishedDate)
        
        self.article = article
    }
    
    //MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.article.id)
    }
    
    static func == (lhs: NewsItemViewModel, rhs: NewsItemViewModel) -> Bool {
        return lhs.article.id == rhs.article.id
    }
}
