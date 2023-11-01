//
//  NetworkingManagerUnitTests.swift
//  SearchGithubUnitTests
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import Foundation
import XCTest
import SearchGithub

class NetworkingManagerUnitTests: XCTestCase {
    func test_fetchData_isSuccess() async {
        // Given
        let mockSession = MockURLSession()
        let manager = NetworkManager(urlSession: mockSession)
        
        let testData = Data()
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        // When
        mockSession.data = testData
        mockSession.response = response
        
        // Then
        do {
            // Test your fetch method
            let user = try await manager.fetch(from: .users(username: "testUser"), model: String.self)
            XCTAssertNotNil(user)
            // Add assertions for the expected results
        } catch {
            XCTFail("Failed to fetch data: \(error)")
        }
    }
    
}
