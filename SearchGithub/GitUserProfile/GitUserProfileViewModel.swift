//
//  GitUserProfileViewModel.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 02/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

class GitUserProfileViewModel {
    private let networkManager = NetworkManager()
    private let coreDataManager = CoreDataManager.shared
    private let bag = DisposeBag()
    
    let userInfo = PublishRelay<GitUserModel>()
    let loading = BehaviorRelay(value: true)
    
    init() { }
    
    func fetchUser(_ user: GitUserModel) {
        Task {
        // TODO: Query LocalStorage first - available load that else load remote content
            do {
                let storedUser = try coreDataManager.fetchUser(with: "login", value: user.login)
                if let storedUser {
                    userInfo.accept(storedUser)
                    return
                }
                let gitUser = try await networkManager.fetch(from: .github, path: .users(username: user.login), model: GitUserModel.self)
                userInfo.accept(gitUser)
                saveGitUserLocally(gitUser)
                loading.accept(false)
            } catch {
                // TODO: Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveGitUserLocally(_ user: GitUserModel) {
        coreDataManager.saveGitUser(user)
    }
}
