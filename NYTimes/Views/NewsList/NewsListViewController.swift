//
//  NewsListViewController.swift
//  NYTimes
//
//  Created by Alex on 18/11/2020.
//

import UIKit
import RxSwift
import RxCocoa

final class NewsListViewController<Repo: PopularNewsRepo>: UIViewController, UITableViewDelegate {
    private enum Section: CaseIterable {
        case all
    }

    private lazy var tableView = self.makeTableView()
    private lazy var errorLabel = self.makeErrorLabel()

    private var viewModel = NewsListViewModel<Repo>()
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.layoutViews()
        self.setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selected = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selected, animated: true)
        }
    }

    // MARK: - Layout

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

    // MARK: - User Interaction

    @objc private func selectDays() {
        let actionSheet = UIAlertController(title: "Select days", message: nil, preferredStyle: .actionSheet)
        let days = [1, 7, 30]
        for day in days {
            let title = (self.viewModel.days.value == day ? "✓ " : "") + String(day) + " " + (day == 1 ? "day" : "days")
            actionSheet.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] (_) in
                self?.viewModel.daySelected(days: day)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - Setup

    private func setupBindings() {
        self.viewModel.title.bind(to: self.rx.title).disposed(by: self.disposeBag)

        self.viewModel.isLoading.bind(to: self.tableView.rx.isHidden).disposed(by: self.disposeBag)

        self.viewModel.error.bind { [weak self] (error) in
            self?.errorLabel.isHidden = error == nil
            self?.tableView.isHidden = error != nil
            self?.errorLabel.text = error?.localizedDescription
        }.disposed(by: self.disposeBag)

        self.viewModel.articles.bind(to: self.tableView.rx.items(cellIdentifier: "NewsListTableViewCell")) { (_, model, cell: NewsListTableViewCell) in
            cell.setup(with: model)
        }.disposed(by: self.disposeBag)

        self.tableView.rx.modelSelected(NewsItemViewModel.self).map({ $0.article }).subscribe(onNext: { [weak self] (article) in
            let viewModel = ArticleViewModel(with: article)
            let viewController = ArticleViewController(rootView: ArticleView(with: viewModel))
            self?.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: self.disposeBag)
    }

    // MARK: - UI

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
