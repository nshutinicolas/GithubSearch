//
//  EngagementViewController.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 02/11/2023.
//

import UIKit
import RxSwift
import RxCocoa

class EngagementViewController: UIViewController {
    typealias Engagement = QueryBuilder.UserPath
    private let bag = DisposeBag()
    
    public let viewModel = EngagementViewModel()
    public var coordinator: EngagementCoordinator?
    
    init(with user: GitUserModel, engagement: Engagement) {
        super.init(nibName: nil, bundle: nil)
        viewModel.fetchUsers(for: user.login, engagement: engagement)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var usersTableView: UITableView = {
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
        view.addSubview(usersTableView)
        bindTableViewController()
        bindViewModelMethods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLayoutConstraint.activate([
            usersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindTableViewController() {
        usersTableView.rx.setDelegate(self).disposed(by: bag)
        usersTableView.rx.modelSelected(GitUserModel.self)
            .subscribe(onNext: { [weak self] user in
                guard let self else { return }
                self.viewModel.selectedUser.onNext(user)
                if let indexPath = self.usersTableView.indexPathForSelectedRow {
                    self.usersTableView.deselectRow(at: indexPath, animated: true)
                }
            })
            .disposed(by: bag)
    }
    
    private func bindViewModelMethods() {
        viewModel.users.bind(to: usersTableView.rx.items(cellIdentifier: SearchResultsTableCell.identifier, cellType: SearchResultsTableCell.self)) { row, item, cell in
            cell.updatedUser(username: item.login, imageUrl: item.avatarUrl)
        }.disposed(by: bag)
    }
}

extension EngagementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
