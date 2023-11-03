//
//  GitUserProfileView.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 03/11/2023.
//

import UIKit

class GitUserProfileView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    private func setupView() {
        addSubview(mainStack)
        [profileStack, engagementStack].forEach { mainStack.addArrangedSubview($0) }
        
        // Constraints
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func updateContent(user: GitUserModel) {
        profileImageView.loadImage(from: user.avatarUrl)
        nameLabel.text = user.name
        usernameLabel.text = user.login
        bioLabel.text = user.bio
        followersCount.text = "\(user.followers ?? 0)"
        followingCount.text = "\(user.following ?? 0)"
    }
    
    // MARK: - Views
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.distribution = .fill
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 8
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemBackground
        stack.layer.shadowRadius = 2
        stack.layer.shadowOffset = .init(width: 5, height: 5)
        stack.layer.shadowColor = UIColor.tertiarySystemBackground.cgColor
        stack.layer.shadowOpacity = 1
        return stack
    }()
    private lazy var profileStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, profileLabelStack])
        stack.spacing = 8
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.alignment = .center
        stack.layer.cornerRadius = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var profileImageView: RemoteImage = {
        let imageView = RemoteImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    private lazy var profileLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel, bioLabel])
        stack.spacing = 4
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Followers and Location section
    private lazy var engagementStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [engagementIcon, followersCount, followersLabel, followingCount, followingLabel])
        stack.setCustomSpacing(10, after: engagementIcon)
        stack.spacing = 4
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var engagementIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "person.3.sequence.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
