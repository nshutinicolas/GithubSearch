//
//  QueryBuilderUnitTests.swift
//  SearchGithubUnitTests
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import Foundation
import XCTest
import SearchGithub

class QueryBuilderUnitTests: XCTestCase {
    func test_searchGithubEndpoint_isValid() throws {
        let query = "nicolas"
        let builder = QueryBuilder()
//        let url = try XCTUnwrap(builder.url(from: .github, path:))
//        XCTAssertEqual(url.absoluteString, "https://api.github.com/search/users?q=nicolas")
    }
    
    func test_usersGithubEndpoint_isValid() throws {
        let username = "nshutinicolas"
        let builder = QueryBuilder()
//        let url = try XCTUnwrap(builder.url(from: .github, query: .users(username: username)))
//        XCTAssertEqual(url.absoluteString, "https://api.github.com/users/nshutinicolas")
    }
    
    func test_invalidURL() throws {
        let builder = QueryBuilder()
//        let url = builder.url(from: .custom(url: "invalid_url"), path: .users(username: "asdd"))
//        XCTAssertNil(url?.absoluteURL)
    }
}
