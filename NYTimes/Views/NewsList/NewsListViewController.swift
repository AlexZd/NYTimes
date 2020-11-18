//
//  NewsListViewController.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import UIKit
import Combine

final class NewsListViewController<Repo: PopularNewsRepo>: UIViewController {
    private enum Section: CaseIterable {
        case all
    }
    
    private lazy var tableView = self.makeTableView()
    private lazy var errorLabel = self.makeErrorLabel()
    
    private lazy var dataSource = self.makeDataSource()
    
    private var viewModel = NewsListViewModel<Repo>()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.layoutViews()
        self.setupBindings()
        self.viewModel.load()
    }
    
    //MARK: - Layout
    
    private func layoutViews() {
        self.view.addSubview(self.tableView)
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(self.errorLabel)
        self.errorLabel.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 1).isActive = true
        self.errorLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        self.errorLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.trailingAnchor, multiplier: -2).isActive = true
    }
    
    //MARK: - Setup
    
    private func setupBindings() {
        self.viewModel.$title.assignNoRetain(to: \.title, on: self).store(in: &self.subscriptions)

        self.viewModel.$articles.sink { [weak self] (articles) in
            self?.update(articles: articles)
        }.store(in: &self.subscriptions)
        
        self.viewModel.$error.sink { [weak self] (error) in
            self?.errorLabel.isHidden = error == nil
            self?.tableView.isHidden = error != nil
            self?.errorLabel.text = error?.localizedDescription
        }.store(in: &self.subscriptions)
    }
    
    //MARK: - Utils
    
    func update(articles: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.all])
        snapshot.appendItems(articles)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    //MARK: - UI
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Article> {
        return UITableViewDiffableDataSource(tableView: self.tableView, cellProvider: {  tableView, indexPath, article in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = article.title
            return cell
        })
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        return tableView
    }
    
    private func makeErrorLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }
}
