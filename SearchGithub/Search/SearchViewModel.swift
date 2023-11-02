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
    
    let storedUsersRelay = PublishRelay<[GitUserModel]>()
    var storedUsersModel: [GitUserModel] = []
    
    
    func fetchStoredUsers() {
        let users = coreDataManager.fetchUsers()
        storedUsersRelay.accept(users)
        storedUsersModel = users
    }
}
