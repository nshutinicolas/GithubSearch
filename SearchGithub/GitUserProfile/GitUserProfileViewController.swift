//
//  GitUserProfileViewController.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * Implement loading for this screen - when looking for a new user info
 * The initializeer is quite weird. Fix it
 * Some logic should go to the view model - For testing purposes
 * A lot of mess - Declutter this VC
 * Reeactiveness is .zero - Fix that part
 * make the VC reactive fully and abort delegates
 */

class GitUserProfileViewController: UIViewController {
    public var coordinator: GitUserProfileCoordinator?
    private let networkManager = NetworkManager()
    private let bag = DisposeBag()
    let viewModel = GitUserProfileViewModel()
    
    let user = PublishRelay<GitUserModel>()
    
    // TODO: Consider initiliazing the view with user model first
    init() {
        super.init(nibName: nil, bundle: nil)
        // TODO: Remove this infavor of initializer
        self.user.subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.viewModel.fetchUser(user)
        }).disposed(by: bag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(mainStack)
        view.addSubview(userProfileTableView)
        userProfileTableView.delegate = self
        userProfileTableView.dataSource = self
        userProfileTableView.reloadData()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMainStackConstraints()
        configureMainStack()
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            userProfileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            userProfileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userProfileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userProfileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupMainStackConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
    }
    private func configureMainStack() {
        [userProfileView,
         userProfileTableView
        ].forEach { mainStack.addArrangedSubview($0) }
    }
    
    private lazy var userProfileTableView: UITableView = {
        let table = UITableView()
        table.separatorInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        table.register(SearchResultsTableCell.self, forCellReuseIdentifier: SearchResultsTableCell.identifier)
        table.register(ProfileEngagemenTitleSectionView.self, forHeaderFooterViewReuseIdentifier: ProfileEngagemenTitleSectionView.identifier)
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 0
        stack.distribution = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Views
    
    private lazy var userProfileView: GitUserProfileView = {
        let view = GitUserProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // TODO: Arrange these methods
    @objc private func navigateToFollowers() {
        // Get the value from The Relay - Temporary workaround
        if let userModel = viewModel.userProfileInfo {
            coordinator?.navigateToEngagement(for: userModel, engagement: .followers)
        }
    }
    @objc private func navigateToFollowing() {
        if let userModel = viewModel.userProfileInfo {
            coordinator?.navigateToEngagement(for: userModel, engagement: .following)
        }
    }
    private func navigateToEngagement(_ engagement: QueryBuilder.UserPath) {
        if let userModel = viewModel.userProfileInfo {
            coordinator?.navigateToEngagement(for: userModel, engagement: engagement)
        }
    }
}

extension GitUserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.engagements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.engagements[section].profiles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileEngagemenTitleSectionView.identifier) as? ProfileEngagemenTitleSectionView else { return nil }
        let engagements = viewModel.engagements[section]
        view.updateContent(with: engagements.title, count: engagements.profiles.count)
        // Since I know the sections by heart here. I'll have to hard code this part
        view.clickAction = { [weak self] in
            guard let self else { return }
            switch section {
            case 0: // Represents Followers
                self.navigateToEngagement(.followers)
            case 1: // Represents Followings
                self.navigateToEngagement(.following)
            default:
                // Nothing to show
                break
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableCell.identifier, for: indexPath) as? SearchResultsTableCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Label \(indexPath.section)-\(indexPath.row)"
            return cell
        }
        let user = viewModel.engagements[indexPath.section].profiles[indexPath.row]
        cell.updatedUser(username: user.login, imageUrl: user.avatarUrl)
        return cell
    }
    
    // TODO: Implement this method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Since I know that section 1 is followers and section 2 is following - I'll hard codee this part
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        default:
            // Nothing to show
            break
        }
    }
}

// MARK: - ViewModel Delegate
extension GitUserProfileViewController: GitUserProfileViewModelDelegate {
    func reloadEngagementTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.userProfileTableView.reloadData()
        }
    }
    func updateUserInfo(_ user: GitUserModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.userProfileView.updateContent(user: user)
        }
    }
    
    func updateEngagements(_ sections: [EngagementSection]) {
        // Not sure why I need
    }
    
    func loadingState(_ state: LoadingState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch state {
            case .loading:
                self.mainStack.isHidden = true
            case .complete:
                self.mainStack.isHidden = false
            case .failed:
                // Present Error state view
                break
            }
        }
    }
}
