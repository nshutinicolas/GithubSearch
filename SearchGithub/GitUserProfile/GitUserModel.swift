//
//  GitUserModel.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 02/11/2023.
//

import Foundation

public struct GitUserModel: Identifiable, Decodable {
    public let id: Int
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
    let location: String?
}

public struct GitResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [GitUserModel]
}
