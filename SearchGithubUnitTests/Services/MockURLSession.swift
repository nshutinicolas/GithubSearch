//
//  MockURLSession.swift
//  SearchGithubUnitTests
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import Foundation
import SearchGithub

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        guard let data, let response else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
