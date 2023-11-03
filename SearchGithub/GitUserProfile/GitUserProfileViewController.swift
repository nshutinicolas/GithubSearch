//
//  GitUserProfileViewController.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class GitUserProfileViewController: UIViewController {
    public var coordinator: GitUserProfileCoordinator?
    private let networkManager = NetworkManager()
    private let bag = DisposeBag()
    let viewModel = GitUserProfileViewModel()
    private var userModel: GitUserModel?
    
    let user = PublishRelay<GitUserModel>()
    
    // TODO: Consider initiliazing the view with user model first
    init() {
        super.init(nibName: nil, bundle: nil)
        // TODO: Remove this infavor of initializer
        self.user.subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.viewModel.fetchUser(from: user.login)
        }).disposed(by: bag)
        
        viewModel.userInfo.subscribe( onNext: { [weak self] user in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateView(with: user)
                self.userModel = user
            }
            self.viewModel.loading.accept(false)
        })
        .disposed(by: bag)
        viewModel.loading.bind(onNext: { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.mainStack.isHidden = state
            }
        })
        .disposed(by: bag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateView(with user: GitUserModel) {
        userProfileView.updateContent(user: user)
        if let followerCount = user.followers, followerCount > 0 {
            followingButton.setTitle("Followers (\(followerCount))", for: .normal)
        }
        if let followingCount = user.following, followingCount > 0 {
            followersButton.setTitle("Following (\(followingCount)", for: .normal)
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.distribution = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(mainStack)
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScrollViewConstraints()
        setupMainStackConstraints()
        configureMainStack()
    }
    
    func fetchData() {
        Task {
        }
    }
    
    func setupScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupMainStackConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
        ])
    }
    func configureMainStack() {
        [userProfileView,
         followButton,
         followingButton,
         followersButton
        ].forEach { mainStack.addArrangedSubview($0) }
    }
    
    // MARK: - Views
    
    private lazy var userProfileView: GitUserProfileView = {
        let view = GitUserProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // TODO: Style the buttons and add them to the view
    private lazy var followButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 10, leading: 5, bottom: 10, trailing: 5)
        config.title = "Follow"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 20
        button.configuration = config
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var followersButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 10, leading: 5, bottom: 10, trailing: 5)
        config.title = "Followers"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        config.image = UIImage(systemName: "shared.with.you")
        config.imagePadding = 20
        button.configuration = config
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(navigateToFollowers), for: .touchUpInside)
        return button
    }()
    private lazy var followingButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 10, leading: 5, bottom: 10, trailing: 5)
        config.title = "Followers"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        config.image = UIImage(systemName: "shared.with.you")
        config.imagePadding = 20
        button.configuration = config
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // TODO: Arrange these methods
    @objc private func navigateToFollowers() {
        // Get the value from The Relay - Temporary workaround
        if let userModel {
            coordinator?.navigateToEngagement(for: userModel, engagement: .followers)
        }
    }
    @objc private func navigateToFollowing() {
        if let userModel {
            coordinator?.navigateToEngagement(for: userModel, engagement: .following)
        }
    }
}
