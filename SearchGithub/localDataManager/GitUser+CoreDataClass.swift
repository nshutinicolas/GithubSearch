//
//  GitUser+CoreDataClass.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 03/11/2023.
//
//

import Foundation
import CoreData

@objc(GitUser)
public class GitUser: NSManagedObject {
    
}

extension GitUser {
    // Might need this 🤷🏿‍♂️
    static func convertToUserModel(from user: GitUser) -> GitUserModel {
        let userModel = GitUserModel(
            id: Int(user.id),
            name: user.name,
            login: user.login ?? "",
            bio: user.bio,
            avatarUrl: user.avatarUrl ?? "",
            url: user.url ?? "",
            followersUrl: user.followersUrl ?? "",
            followingUrl: user.followingUrl ?? "",
            reposUrl: user.reposUrl ?? "",
            followers: Int(user.followers),
            following: Int(user.following),
            publicRepos: Int(user.publicRepos),
            publicGists: Int(user.publicGists),
            location: user.location)
        return userModel
    }
}
