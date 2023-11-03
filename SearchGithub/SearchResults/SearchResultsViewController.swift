//
//  SearchResultsViewController.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import UIKit
import RxSwift

class SearchResultsViewController: UIViewController {
    private let bag = DisposeBag()
    
    public let viewModel = SearchResultsViewModel()
    
    lazy var resultsTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.contentInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        table.separatorInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        table.register(SearchResultsTableCell.self, forCellReuseIdentifier: SearchResultsTableCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.8)
        // TODO: Replce with RxSwift
        view.addSubview(resultsTableView)
        bindTableViewController()
        bindViewModelMethods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLayoutConstraint.activate([
            resultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindTableViewController() {
        resultsTableView.rx.setDelegate(self).disposed(by: bag)
        resultsTableView.rx.modelSelected(GitUserModel.self)
            .subscribe(onNext: { [weak self] user in
                guard let self else { return }
                self.viewModel.selectedUser.onNext(user)
                if let indexPath = self.resultsTableView.indexPathForSelectedRow {
                    self.resultsTableView.deselectRow(at: indexPath, animated: true)
                }
            })
            .disposed(by: bag)
    }
    
    private func bindViewModelMethods() {
        viewModel.searchResults.bind(to: resultsTableView.rx.items(cellIdentifier: SearchResultsTableCell.identifier, cellType: SearchResultsTableCell.self)) { row, item, cell in
            cell.updatedUser(username: item.login, imageUrl: item.avatarUrl)
        }.disposed(by: bag)
        
        viewModel.isViewHidden.bind(to: view.rx.isHidden)
            .disposed(by: bag)
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
