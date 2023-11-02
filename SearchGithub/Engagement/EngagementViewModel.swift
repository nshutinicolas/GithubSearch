//
//  EngagementViewModel.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 02/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

class EngagementViewModel {
    private let networkManager = NetworkManager()
    
    let users = PublishRelay<[GitUserModel]>()
    let selectedUser = PublishSubject<GitUserModel>()
    let loading = BehaviorRelay(value: true)
    
    func fetchUsers(for username: String, engagement: QueryBuilder.UserPath) {
        Task {
            do {
                let gitUsers = try await networkManager.fetch(from: .github, path: .users(username: username, path: engagement), model: [GitUserModel].self)
                users.accept(gitUsers)
                loading.accept(false)
            } catch {
                // TODO: Handle Error
                print(error.localizedDescription)
            }
        }
    }
}
