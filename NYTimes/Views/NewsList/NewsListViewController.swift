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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.layoutViews()
        self.setupBindings()
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
        self.errorLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(selectDays))
    }
    
    //MARK: - User Interaction
    
    @objc private func selectDays() {
        let actionSheet = UIAlertController(title: "Select days", message: nil, preferredStyle: .actionSheet)
        let days = [1, 7, 30]
        for day in days {
            let title = (self.viewModel.days == day ? "✓ " : "") + String(day) + " " + (day == 1 ? "day" : "days")
            actionSheet.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] (action) in
                self?.viewModel.daySelected(days: day)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Setup
    
    private func setupBindings() {
        self.viewModel.$title.assignNoRetain(to: \.title, on: self).store(in: &self.subscriptions)
        
        self.viewModel.$isLoading.assignNoRetain(to: \.isHidden, on: self.tableView).store(in: &self.subscriptions)

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
    
    func update(articles: [NewsItemViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItemViewModel>()
        snapshot.appendSections([.all])
        snapshot.appendItems(articles)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    //MARK: - UI
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, NewsItemViewModel> {
        return UITableViewDiffableDataSource(tableView: self.tableView, cellProvider: {  tableView, indexPath, article in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListTableViewCell", for: indexPath) as? NewsListTableViewCell else { return nil }
            cell.setup(with: article)
            return cell
        })
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: "NewsListTableViewCell")
        tableView.tableFooterView = UIView()
        return tableView
    }
    
    private func makeErrorLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }
}
