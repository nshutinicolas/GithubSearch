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
    private let bag = DisposeBag()
    
    let userInfo = PublishRelay<GitUserModel>()
    let loading = BehaviorRelay(value: true)
    
    init() { }
    
    func fetchUser(from username: String) {
        Task {
            do {
                let gitUser = try await networkManager.fetch(from: .github, path: .users(username: username), model: GitUserModel.self)
                userInfo.accept(gitUser)
                loading.accept(false)
            } catch {
                // TODO: Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
