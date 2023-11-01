//
//  QueryBuilder.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import Foundation

/**
 * I want to have https://api.github.com - base uri
 * pages: search/users and users/{username}
 */

public struct QueryBuilder {
    public init() { }
    
    public enum BaseUrl {
        case github
        case custom(url: String)
        var urlString: String {
            switch self {
            case .github: return "https://api.github.com/"
            case .custom(let url): return url
            }
        }
    }
    public enum EndPoint {
        case search(query: String)
        case users(username: String)
        
        var string: String {
            switch self {
            case .search(let query):
                return "search/users?q=\(query)&per_page=10" // TODO: Remove the constants use QueryItem...
            case .users(let username):
                return "users/\(username)"
            }
        }
    }
    // TODO: Modify EndPoint to refactor in QueryItem in search
    // How to do it!!!
    public enum QueryItem {
        case perPage(number: Int)
        case query(q: String)
    }
    
    public func url(from baseUrl: BaseUrl, query: EndPoint) -> URL? {
        let stringUrl = baseUrl.urlString+query.string
        guard let url = URL(string: stringUrl) else { return nil }
        return url
    }
}
