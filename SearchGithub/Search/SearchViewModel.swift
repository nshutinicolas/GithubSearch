//
//  SearchViewModel.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import Foundation
import RxCocoa
import RxSwift

class SearchViewModel {
    private let gitUserManager = GitUserManager()
    
    let storedUsersRelay = BehaviorRelay<[GitUserModel]>(value: [])
    var storedUsersModel: [GitUserModel] = []
    let selectedUser = PublishSubject<GitUserModel>()
    
    init() { }
    
    func fetchStoredUsers() {
        // TODO: Review if there is need to handle this error!!???
        let users = try? gitUserManager.fetchAllSavedUsers()
        guard let users else { return }
        storedUsersRelay.accept(users)
        storedUsersModel = users
    }
}
