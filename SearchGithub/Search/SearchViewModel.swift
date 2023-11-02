//
//  SearchViewModel.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import Foundation
import RxCocoa
import RxSwift

struct UserModel: Identifiable, Decodable {
    let id: Int
    let name: String?
    let login: String
    let bio: String?
    let avatarUrl: String
    let url: String
    let followersUrl: String
    let followingUrl: String
    let reposUrl: String
    let followers: Int?
    let following: Int?
    let publicRepos: Int?
    let publicGists: Int?
}

struct GitResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [UserModel]
}

// Temporary implementation
protocol SearchViewModelDelegate {
    func updateSearchResults(_ results: [UserModel])
}

class SearchViewModel {
    private let networkManager = NetworkManager()
    
    var searchResults = BehaviorRelay(value: [UserModel]())
    var searchText = BehaviorSubject(value: "")
    var selectedUser = PublishSubject<UserModel>()
    init() {
        
    }
    
//    =========Search Method==========
    /// Context:
    /// Searching hits https://api.github.com/search/users?q={query}
    /// Initiate search when query string is 3 and more characters
    /// Add a delay to the typing. hit search after like 2 secs of debounce search
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
