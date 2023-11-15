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
    private var builder: QueryBuilder!
    
    override func setUp() {
        super.setUp()
        builder = QueryBuilder()
    }
    
    override func tearDown() {
        builder = nil
        super.tearDown()
    }
    
    func test_githubEndPoint() {
        let github = builder.url(from: .github)
        XCTAssertEqual(github?.absoluteString, "https://api.github.com/")
    }
    
    func test_searchGithubEndpoint_isValid() throws {
        let query = "nicolas"
        let url = try XCTUnwrap(builder.url(from: .github, path: .search, queries: [.query(q: query)]))
        XCTAssertEqual(url.absoluteString, "https://api.github.com/search/users?q=nicolas")
    }
    
    func test_usersGithubEndpoint_isValid() throws {
        let username = "nicolas"
        let url = try XCTUnwrap(builder.url(from: .github, path: .users(username: username)))
        XCTAssertEqual(url.absoluteString, "https://api.github.com/users/nicolas")
    }
    
    func test_usersGithubEndPoint_withSearchQuery_shouldBeIgnored() throws {
//        let username = "nicolas"
//        let url = try XCTUnwrap(builder.url(from: .github, path: .users(username: username), queries: [.page(number: 10)]))
//        XCTAssertEqual(url.absoluteString, "https://api.github.com/users/nicolas")
    }
    
    func test_customUrl() throws {
        let customUrl = "https://endpoint.com"
        let url = builder.url(from: .custom(url: customUrl))
        XCTAssertNotNil(url?.absoluteURL)
    }
    
    func test_invalidURL() throws {
        let invalidUrl = "invalid_url"
        let url = builder.url(from: .custom(url: invalidUrl))
        XCTAssertNil(url?.scheme)
    }
}

/**
 * Test URL Queries
 * Test Invalid content
 * User EP does not take search query(ie: q) - Test out this scenario to validate that option
 */
