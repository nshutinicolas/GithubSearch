//
//  GitUserProfileViewModel.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 02/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct EngagementSection {
    let title: String
    let profiles: [GitUserModel]
}

enum LoadingState {
    case loading, complete, failed
}

// TODO: Utilize RxSwift to remove this delegate method
/// Doing oldshool delegates🤟🏿
protocol GitUserProfileViewModelDelegate {
    func loadingState(_ state: LoadingState)
    func reloadEngagementTable()
    func updateUserInfo(_ user: GitUserModel)
    func updateEngagements(_ sections: [EngagementSection])
}

class GitUserProfileViewModel {
    private let networkManager = NetworkManager()
    private let coreDataManager = CoreDataManager.shared
    
    var userProfileInfo: GitUserModel?
    var engagements = [EngagementSection]()
    var delegate: GitUserProfileViewModelDelegate?
    
    init() {
        // Not the best place but works for now
        delegate?.loadingState(.loading)
    }
    
    func fetchUser(_ user: GitUserModel) {
        Task {
        // TODO: Query LocalStorage first - available load that else load remote content
            do {
                let storedUser = try coreDataManager.fetchUser(with: "login", value: user.login)
                if let storedUser {
                    userProfileInfo = storedUser
                    delegate?.updateUserInfo(storedUser)
                    getEngagement(for: storedUser)
                    return
                }
                let gitUser = try await networkManager.fetch(from: .github, path: .users(username: user.login), model: GitUserModel.self)
                userProfileInfo = gitUser
                saveGitUserLocally(gitUser)
                getEngagement(for: gitUser)
                // Delegate
                delegate?.loadingState(.complete)
                delegate?.updateUserInfo(gitUser)
            } catch {
                // TODO: Handle error
                print("Error: \(error.localizedDescription)")
                delegate?.loadingState(.failed)
            }
        }
    }
    
    private func getEngagement(for user: GitUserModel) {
        Task {
            do {
                async let gitFollowers = networkManager.fetch(from: .github, path: .users(username: user.login, path: .followers), queries: [.page(number: 1), .perPage(number: 10)], model: [GitUserModel].self)
                async let gitFollowing = networkManager.fetch(from: .github, path: .users(username: user.login, path: .following), queries: [.page(number: 1), .perPage(number: 10)], model: [GitUserModel].self)
                
                let (followers, following) = try await (gitFollowers, gitFollowing)
                let engagements: [EngagementSection] = [
                    EngagementSection(title: "Followers", profiles: followers),
                    EngagementSection(title: "Following", profiles: following)
                ]
                self.engagements = engagements
                delegate?.reloadEngagementTable()
            } catch {
                // TODO: Handle this error
                print("Error in \(#function): \(error.localizedDescription)")
            }
        }
    }
    
    func saveGitUserLocally(_ user: GitUserModel) {
        coreDataManager.saveGitUser(user)
    }
}
