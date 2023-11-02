//
//  SearchResultsTableCell.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import UIKit

class SearchResultsTableCell: UITableViewCell {
    static let identifier = "SearchResultsTableCell"
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.distribution = .fillProportionally
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
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func updatedUser(username: String, imageUrl: String) {
        usernameLabel.text = username
        profileImageView.loadImage(from: imageUrl)
    }
    
    private func setupView() {
        contentView.addSubview(mainStack)
        setupMainView()
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    private func setupMainView() {
        [profileImageView, usernameLabel].forEach { view in
            mainStack.addArrangedSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
