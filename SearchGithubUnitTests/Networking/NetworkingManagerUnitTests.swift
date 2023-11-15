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
    let mockSession = MockURLSession()
    
    func test_fetchData_isSuccess() async {
        // Given
        let manager = NetworkManager(urlSession: mockSession)
        let response = HTTPURLResponse(url: URL(string: "https://api.github.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        // When
        mockSession.data = TestData.mockGitUsers
        mockSession.response = response
        // Then
        do {
            let user = try await manager.fetch(from: .github, model: [GitUserModel].self)
            XCTAssertNotNil(user)
            XCTAssertEqual(user.count, 5)
        } catch {
            XCTFail("Failed to fetch data: \(error)")
        }
    }
    
    func test_fetchData_isFailed() async {
        // Given
        let manager = NetworkManager(urlSession: mockSession)
        let response = HTTPURLResponse(url: URL(string: "https://api.github.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        // When
        mockSession.data = TestData.invalidGitUsers
        mockSession.response = response
        // Then
        do {
            let _ = try await manager.fetch(from: .github, model: [GitUserModel].self)
            XCTFail("Failed to throw error")
        } catch {
            XCTAssertTrue(true, "Failed with correct error: \(error.localizedDescription)")
        }
    }
    
    func test_fetchData_HTTPURLResponse_isInvalid() async {
        let manager = NetworkManager(urlSession: mockSession)
        let response = HTTPURLResponse(url: URL(string: "https://api.github.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        // When
        mockSession.data = Data()
        mockSession.response = response
        // Then
        do {
            let _ = try await manager.fetch(from: .github, model: [GitUserModel].self)
            XCTFail("Failed to throw error")
        } catch let error as URLError {
            if error.code == .badServerResponse {
                XCTAssertTrue(true, "Invalid data should not be decoded")
            } else {
                XCTFail("Expected bad server error to be thrown.")
            }
        } catch {
            XCTFail("Should throw URLError")
        }
    }
}
