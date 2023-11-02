//
//  GitUserProfileViewController.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import UIKit
struct User: Decodable {
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: URL
    let gravatarId: String
    let url: URL
}

class GitUserProfileViewController: UIViewController {
    public var coordinator: GitUserProfileCoordinator?
    private let networkManager = NetworkManager()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
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
//            do {
//                let user = try await networkManager.fetch(from: .users(username: "nshutinicolas"), model: User.self)
//                print(user)
//            } catch {
//                print("Error: \(error.localizedDescription)")
//            }
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
//            mainStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
        ])
    }
    func configureMainStack() {
        [userBioStack, followButton].forEach { view in
            mainStack.addArrangedSubview(view)
        }
        NSLayoutConstraint.activate([
            profileImageBlock.heightAnchor.constraint(equalToConstant: 60),
            profileImageBlock.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    // MARK: - User Bio Views
    private lazy var userBioStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileViewStack, locationStack, engagementStack])
        stack.spacing = 8
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var profileViewStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageBlock, labelBioStack])
        stack.spacing = 8
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var labelBioStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        stack.spacing = 4
        stack.distribution = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nicolas Nshuti"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "nshutinicolas"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var profileImage: RemoteImage = {
        let image = RemoteImage()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var profileImageBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var locationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
        stack.spacing = 4
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "location.north.circle.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.frame = .init(x: .zero, y: .zero, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Kigali, Rwanda"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var engagementStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [engagementIcon, followersCount, followersLabel, followingCount, followingLabel])
        stack.setCustomSpacing(10, after: engagementIcon)
        stack.spacing = 4
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var engagementIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "person.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.frame = .init(x: .zero, y: .zero, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    // TODO: Make this clickable
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var followersCount: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var followersIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "person.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var followingCount: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Follow", for: .normal)
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 10, leading: 5, bottom: 10, trailing: 5)
        button.configuration = config
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

