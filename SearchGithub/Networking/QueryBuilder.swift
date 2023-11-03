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
 * Still experimental
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
    public enum Path {
        case search
        case users(username: String, path: UserPath? = nil)
        
        var string: String {
            switch self {
            case .search:
                return "search/users"
            case .users(let username, let path):
                guard let path else { return "users/\(username)"}
                return "users/\(username)/\(path)"
            }
        }
    }
    public enum UserPath: String {
        case followers, following
    }
    // TODO: Modify EndPoint to refactor in QueryItem in search
    // How to do it!!!
    public enum QueryItem {
        case perPage(number: Int)
        case query(q: String)
        case page(number: Int)
        
        var key: String {
            switch self {
            case .page(_): return "page"
            case .perPage(_): return "per_page"
            case .query(_): return "q"
            }
        }
        
        var value: String {
            switch self {
            case .perPage(let number):
                return "\(number)"
            case .query(let q):
                return "\(q)"
            case .page(let number):
                return "\(number)"
            }
        }
    }
    
    public func url(from baseUrl: BaseUrl, path: Path? = nil, queries: [QueryItem] = []) -> URL? {
        var queryItems: [URLQueryItem] = []
        queries.forEach { queryItems.append(URLQueryItem(name: $0.key, value: $0.value)) }
        
        var urlComponents = URLComponents(string: baseUrl.urlString)
        if let path {
            urlComponents?.path += path.string
        }
        
        urlComponents?.queryItems = queryItems.isEmpty ? nil : queryItems
        guard let url = urlComponents?.url else { return nil }
        return url
    }
}
