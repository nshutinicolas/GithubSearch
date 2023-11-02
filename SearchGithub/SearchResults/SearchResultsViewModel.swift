//
//  SearchResultsViewModel.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import UIKit
import RxCocoa
import RxSwift

class SearchResultsViewModel {
    private let networkManager = NetworkManager()
    
    var searchResults = BehaviorRelay(value: [GitUserModel]())
    var selectedUser = PublishSubject<GitUserModel>()
    
    var isViewHidden = BehaviorRelay(value: true) // TODO: Use this to set the view state!!
    
    init() { }
    
//    =========Search Method==========
    /// Context:
    /// Searching hits https://api.github.com/search/users?q={query}
    /// Initiate search when query string is 3 and more characters
    /// Add a delay to the typing. hit search after like 2 secs of debounce search
    /// Figure out pagination sequence
    func searchGithubUser(named name: String?) {
        guard let name = name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), name.count > 2 else { return }
        Task {
            do {
                let searchResults = try await networkManager.fetch(from: .github, path: .search(query: name), model: GitResponse.self)
                print(searchResults.totalCount) //<- Scam
                self.searchResults.accept(searchResults.items)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
