//
//  StoredGitUsersTableCell.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 03/11/2023.
//

import UIKit

class StoredGitUsersTableCell: UITableViewCell {
    static let identifier = "StoredGitUsersTableCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: topAnchor),
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileView.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContent(with user: GitUserModel) {
        profileView.updateContent(user: user)
    }
    
    // MARK: - Views
    private lazy var profileView: GitUserProfileView = {
        let view = GitUserProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
