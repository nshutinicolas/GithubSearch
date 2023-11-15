//
//  CoreDataManagerUnitTests.swift
//  SearchGithubUnitTests
//
//  Created by Nicolas Nshuti on 14/11/2023.
//

import Foundation
import CoreData
import SearchGithub
import XCTest

class CoreDataManagerUnitTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    var gitUserManager: GitUserManager!
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        coreDataManager.loadStore(for: .inMemory)
        
        gitUserManager = GitUserManager(mainContext: coreDataManager.mainContext)
    }
    
    override func tearDown() {
        coreDataManager = nil
        gitUserManager = nil
        
        super.tearDown()
    }
    
    func test_saveUserLocally() throws {
        // Given
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let mockUsers = try jsonDecoder.decode([GitUserModel].self, from: TestData.mockGitUsers!) // 🚨 Force unwrap
        let singleUser = try XCTUnwrap(mockUsers.first)
        // When
        gitUserManager.addUser(singleUser)
        // Then
        let allUsers = try gitUserManager.fetchAllSavedUsers()
        XCTAssertEqual(allUsers.count, 1)
    }
    
    func test_fetchAllStoredUsers() {
        
    }
}
