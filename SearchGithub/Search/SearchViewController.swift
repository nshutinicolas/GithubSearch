//
//  SearchViewController.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    private let bag = DisposeBag()
    
    public var coordinator: SearchCoordinator?
    
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
    
    private lazy var searchResultsViewController = SearchResultsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        view.addSubview(searchTextField)
        view.addSubview(emptyViewStack)
        addChild(searchResultsViewController)
        view.addSubview(searchResultsViewController.view)
        searchResultsViewController.didMove(toParent: self)
        searchResultsViewController.view.isHidden = true

        searchResultsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        bindSearchTextField()
        bindSearchResultsViewModel()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    private func bindSearchTextField() {
        searchTextField.rx.text
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { text in
                guard let text, text.count > 2 else { return false }
                return true
            }
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                self.searchResultsViewController.viewModel.searchGithubUser(named: text)
            })
            .disposed(by: bag)
        
        searchTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext:{ [weak self] in
                guard let self else { return }
                self.searchResultsViewController.view.isHidden = false
            })
            .disposed(by: bag)
    }
    
    private func bindSearchResultsViewModel() {
        searchResultsViewController.viewModel.selectedUser.subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.coordinator?.navigateToProfile()
        })
        .disposed(by: bag)
    }
}
