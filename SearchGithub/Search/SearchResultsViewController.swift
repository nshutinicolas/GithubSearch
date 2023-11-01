//
//  SearchResultsViewController.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    private lazy var resultsTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.separatorInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        table.register(SearchResultsTableCell.self, forCellReuseIdentifier: SearchResultsTableCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // TODO: Replce with RxSwift
        view.addSubview(resultsTableView)
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
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
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableCell.identifier, for: indexPath) as? SearchResultsTableCell else {
            return UITableViewCell()
        }
        cell.updatedUser(imageName: "", username: "User - \(indexPath.row)")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //            let model = conversations[indexPath.row]
        //            openConversation(model)
    }
}
extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}

class SearchResultsTableCell: UITableViewCell {
    static let identifier = "SearchResultsTableCell"
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
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
    
    func updatedUser(imageName: String, username: String) {
        usernameLabel.text = username
    }
    
    private func setupView() {
//        contentView.addSubview(profileImageView)
//        contentView.addSubview(usernameLabel)
//        NSLayoutConstraint.activate([
//            profileImageView.heightAnchor.constraint(equalToConstant: 60),
//            profileImageView.widthAnchor.constraint(equalToConstant: 60),
//            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            profileImageView.topAnchor.constraint(equalTo: topAnchor),
//            usernameLabel.topAnchor.constraint(equalTo: topAnchor),
//            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
//            usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
//            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
//        ])
        contentView.addSubview(mainStack)
        setupMainView()
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            mainStack.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, constant: 20)
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
