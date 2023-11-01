//
//  SearchViewController.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import UIKit

class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.placeholder = "Search with username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private lazy var emptyViewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var emptyTitle: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Github Search."
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = UIColor.label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchResultsViewController: UIViewController = {
        let searchResultsVC = SearchResultsViewController()
        return searchResultsVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        view.addSubview(emptyViewStack)
        addChild(searchResultsViewController)
        view.addSubview(searchResultsViewController.view)
        searchResultsViewController.didMove(toParent: self)
        searchResultsViewController.view.isHidden = true

        searchResultsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set Search Text Field Constraints
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        setupEmptyViewConstraints()
        setupSearchResultsVCConstraints()
    }
    
    private func setupSearchResultsVCConstraints() {
        NSLayoutConstraint.activate([
            searchResultsViewController.view.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchResultsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchResultsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchResultsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyViewConstraints() {
        [emptyTitle, searchButton].forEach { view in
            emptyViewStack.addArrangedSubview(view)
        }
        NSLayoutConstraint.activate([
            emptyViewStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyViewStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyViewStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyViewStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: Add animation
        searchResultsViewController.view.isHidden = false
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.searchGithubUser(named: textField.text)
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func updateSearchResults(_ results: [UserModel]) {
        DispatchQueue.main.async {
            // Update the UI
        }
    }
}

