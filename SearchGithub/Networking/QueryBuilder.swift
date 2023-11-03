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
        case search(query: String)
        case users(username: String, path: UserPath? = nil)
        case experiment(username: String, path: UserPath? = nil, queries: [QueryItem])
        
        var string: String {
            switch self {
            case .search(let query):
                return "search/users?q=\(query)&per_page=10" // TODO: Remove the constants use QueryItem
            case .users(let username, let path):
                guard let path else { return "users/\(username)"}
                return "users/\(username)/\(path)"
            case .experiment(let username, _, _):
                return "users/\(username)"
            }
        }
//        var stringPath: String {
//            switch self {
//            case .search(let query):
//                return "search/users" // TODO: Remove the constants use QueryItem
//            case .users(let username, let path):
//                guard let path else { return "users/\(username)"}
//                return "users/\(username)/\(path)"
//            }
//        }
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
    
    public func url(from baseUrl: BaseUrl, path: Path? = nil) -> URL? {
        var stringUrl = baseUrl.urlString
        if let path {
            stringUrl+=path.string
        }
        guard let url = URL(string: stringUrl) else { return nil }
        return url
    }
    
    // TODO: Complete this work
    /// The idea is to have everything work out of the box.
    /// 
    public func urlExperimental(from baseUrl: BaseUrl, path: Path? = nil, queries: [QueryItem]) -> URL? {
        var queryItems: [URLQueryItem] = []
        switch path {
        case .search(_):
            break
        case .users(_, _):
            break
        case .experiment(_, _, let queries):
            queries.forEach { queryItems.append(URLQueryItem(name: $0.key, value: $0.value)) }
            
        default:
            break
        }
        var urlComponents = URLComponents(string: baseUrl.urlString)
        if let path {
            urlComponents?.path = path.string
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return nil }
        return url
    }
}
