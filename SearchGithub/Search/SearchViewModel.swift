//
//  SearchViewModel.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import Foundation
import RxCocoa
import RxSwift

// Temporary implementation
protocol SearchViewModelDelegate {
    func updateSearchResults(_ results: [GitUserModel])
}

class SearchViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    let storedUsersRelay = BehaviorRelay<[GitUserModel]>(value: [])
    var storedUsersModel: [GitUserModel] = []
    
    init() { }
    
    func fetchStoredUsers() {
        // TODO: Review if there is need to handle this error!!???
        let users = try? coreDataManager.fetchUsers()
        guard let users else { return }
        storedUsersRelay.accept(users)
        storedUsersModel = users
    }
}
