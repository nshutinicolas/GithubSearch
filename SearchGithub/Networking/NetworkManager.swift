//
//  NetworkManager.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import Foundation

public protocol URLSessionProtocol {
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionProtocol {
    public func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        let (data, response) = try await data(from: url)
        return (data, response)
    }
}

public class NetworkManager {
    public typealias Path = QueryBuilder.Path
    public typealias BaseUrl = QueryBuilder.BaseUrl
    public typealias Queries = QueryBuilder.QueryItem
    
    private let queryBuilder = QueryBuilder()
    private let decoder = JSONDecoder()
    private var urlSession: URLSessionProtocol
    
    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func fetch<T: Decodable>(from url: BaseUrl, path: Path? = nil, queries: [Queries] = [], model: T.Type) async throws -> T {
        guard let url = queryBuilder.url(from: url, path: path, queries: queries) else { throw URLError(.badURL) }
        let (data, response) = try await urlSession.fetchData(from: url)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(model, from: data)
    }
    
    #if DEBUG
    
    #endif
}
