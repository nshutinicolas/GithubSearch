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
    
    private lazy var searchBarStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search with username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.tertiaryLabel.cgColor
        let paddingView = UIView(frame: .init(origin: .zero, size: .init(width: 10, height: .zero)))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    private lazy var clearSearchButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "xmark")
        config.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.imagePadding = 10
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .secondarySystemBackground
        button.configuration = config
        button.addTarget(self, action: #selector(clearResultSearch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var emptyViewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
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
    private lazy var whoAreYouLookingForLabel: UILabel = {
        let label = UILabel()
        label.text = "Who are you looking for?"
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "magnifyingglass")
        config.title = "Search"
        config.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.imagePadding = 10
        config.baseForegroundColor = .systemBlue
        button.configuration = config
        button.addTarget(self, action: #selector(searchTexfieldFocus), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchResultsViewController = SearchResultsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Github Search"
        // Do any additional setup after loading the view.
        view.addSubview(searchBarStack)
        view.addSubview(emptyViewStack)
        // Add Results VC as child VC
        addChild(searchResultsViewController)
        view.addSubview(searchResultsViewController.view)
        searchResultsViewController.didMove(toParent: self)
        
        setupSearchBar()
        bindSearchTextField()
        bindSearchResultsViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
        // Set Search Text Field Constraints
        setupEmptyViewConstraints()
        setupSearchResultsVCConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearResultSearch()
    }
    
    private func setupSearchBar() {
        [searchTextField, clearSearchButton].forEach { searchBarStack.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            searchBarStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBarStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBarStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            clearSearchButton.heightAnchor.constraint(equalToConstant: 48),
            clearSearchButton.widthAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupSearchResultsVCConstraints() {
        searchResultsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchResultsViewController.view.topAnchor.constraint(equalTo: searchBarStack.bottomAnchor, constant: 10),
            searchResultsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyViewConstraints() {
        [emptyTitle, whoAreYouLookingForLabel, searchButton].forEach { view in
            emptyViewStack.addArrangedSubview(view)
        }
        NSLayoutConstraint.activate([
            emptyViewStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyViewStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyViewStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyViewStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func bindSearchTextField() {
        searchTextField.rx.text
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
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
                self.searchResultsViewController.viewModel.isViewHidden.accept(false)
            })
            .disposed(by: bag)
    }
    
    private func bindSearchResultsViewModel() {
        searchResultsViewController.viewModel.selectedUser.subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.coordinator?.navigateToProfile(of: user)
        })
        .disposed(by: bag)
    }
    
    @objc private func searchTexfieldFocus() {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        } else {
            searchTextField.becomeFirstResponder()
        }
    }
    @objc private func clearResultSearch() {
        if searchTextField.isFirstResponder {
            searchTextField.text = ""
            searchTextField.resignFirstResponder()
            searchResultsViewController.viewModel.isViewHidden.accept(true)
            searchResultsViewController.viewModel.searchResults.accept([])
        }
    }
}
