//
//  NewsListTableViewCell.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import UIKit
import AlamofireImage

final class NewsListTableViewCell: UITableViewCell {
    private lazy var mainStack = self.makeMainStack()
    private lazy var thumbImage = self.makeThumb()
    private lazy var textStack = self.makeTextStack()
    private lazy var titleLabel = self.makeTitleLable()
    private lazy var subtitleLabel = self.makeSubtitleLabel()
    private lazy var dateLabel = self.makeDateLabel()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.thumbImage.image = nil
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
        self.dateLabel.text = nil
    }
    
    //MARK: - Layout
    
    private func layoutViews() {
        self.accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(self.mainStack)
        self.mainStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        self.mainStack.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        self.mainStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4).isActive = true
        self.mainStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
        self.mainStack.addArrangedSubview(self.thumbImage)
        self.thumbImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.thumbImage.widthAnchor.constraint(equalTo: self.thumbImage.heightAnchor).isActive = true
        
        self.mainStack.addArrangedSubview(self.textStack)
        
        self.textStack.addArrangedSubview(self.titleLabel)
        self.textStack.addArrangedSubview(self.subtitleLabel)
        self.textStack.addArrangedSubview(self.dateLabel)
    }
    
    //MARK: - Setup
    
    func setup(with item: NewsItemViewModel) {
        if let url = item.thumbUrl { self.thumbImage.af.setImage(withURL: url) }
        self.thumbImage.isHidden = item.isThumbHidden
        self.titleLabel.text = item.title
        self.subtitleLabel.text = item.subtitle
        self.dateLabel.text = item.date
    }
    
    //MARK: - UI
    
    private func makeMainStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .top
        return stackView
    }
    
    private func makeThumb() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemFill
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }
    
    private func makeTextStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }
    
    private func makeTitleLable() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }
    
    private func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 2
        return label
    }
    
    private func makeDateLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }
}
