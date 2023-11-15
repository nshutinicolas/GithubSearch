//
//  CoreDataManager.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 02/11/2023.
//

import Foundation
import CoreData

/**
 For Unit testing CoreData,
 Need to have `in memory` for unit tests and `persistent` storage for main app work
 Option 1: use a boolean ie `init(persistentMemory: Bool)`
 Option 2: use an enum of `inMemory` and `persistent` ie `init(for memoryType: MemoryType)` - looks better😍
*/

public enum MemoryType {
    case persistent, inMemory
}
public class CoreDataManager {
    public static let shared = CoreDataManager()
    public let mainContext: NSManagedObjectContext
    public let backgroundContext: NSManagedObjectContext
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "LocalDataManager")

        mainContext = persistentContainer.viewContext
        
        // Setup background context
        // For unit testing, Figure out how to pass the background context in the initializer
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
    
    public func loadStore(for memoryType: MemoryType = .persistent) {
        // For unit testing
        if memoryType == .inMemory {
            self.persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                // TODO: Handle this error
                print("Failed to load store; \(error.localizedDescription)")
                return
            }
            print("🎉Store loaded🎉")
        }
    }
}

// TODO: Extract this to a file
public struct GitUserManager {
    private let mainContext: NSManagedObjectContext
    
    // Figure out a better way for this initializer
    public init(mainContext: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        self.mainContext = mainContext
    }
    
    public func addUser(_ user: GitUserModel) {
        let _ = createGitUser(user)
        // TODO: Add a check to eliminate duplication
        saveUser()
    }
    
    public func fetchAllSavedUsers() throws -> [GitUserModel] {
        let fetchRequest: NSFetchRequest<GitUser> = GitUser.fetchRequest()
        let savedUsers = try mainContext.fetch(fetchRequest)
        var userModel: [GitUserModel] = []
        savedUsers.forEach { userModel.append(createGitUserModel($0)) }
        return userModel
    }
    
    public func fetchUser(with key: String, value: String) throws -> GitUserModel? {
        let request: NSFetchRequest<GitUser> = GitUser.fetchRequest()
        request.fetchLimit = 1
        let searchPredicate = NSPredicate(format: "\(key) == %@", value)
        request.predicate = searchPredicate
        let storedUser = try mainContext.fetch(request).first
        // Possibility of returning nil - Look into generic implementation
        guard let storedUser else { return nil }
        return createGitUserModel(storedUser)
    }
    
    private func saveUser() {
        guard mainContext.hasChanges else { return }
        // Should perform in the background thread
        do {
            try mainContext.save()
        } catch {
            // TODO: Handle saving error
            print("Failed to save user with: \(error.localizedDescription)")
        }
    }
    
    private func createGitUser(_ user: GitUserModel) -> GitUser {
        let userContext = GitUser(context: mainContext)
        userContext.id = Int64(user.id)
        userContext.name = user.name ?? ""
        userContext.login = user.login
        userContext.bio = user.bio ?? ""
        userContext.avatarUrl = user.avatarUrl
        userContext.url = user.url
        userContext.followersUrl = user.followersUrl
        userContext.followingUrl = user.followingUrl
        userContext.reposUrl = user.reposUrl
        userContext.followers = Int64(user.followers ?? 0)
        userContext.following = Int64(user.following ?? 0)
        userContext.publicRepos = Int64(user.publicRepos ?? 0)
        userContext.publicGists = Int64(user.publicGists ?? 0)
        userContext.location = user.location ?? ""
        
        return userContext
    }
    
    private func createGitUserModel(_ user: GitUser) -> GitUserModel {
        let userModel = GitUserModel(
            id: Int(user.id),
            name: user.name,
            login: user.login ?? "",
            bio: user.bio,
            avatarUrl: user.avatarUrl ?? "",
            url: user.url ?? "",
            followersUrl: user.followersUrl ?? "",
            followingUrl: user.followingUrl ?? "",
            reposUrl: user.reposUrl ?? "",
            followers: Int(user.followers),
            following: Int(user.following),
            publicRepos: Int(user.publicRepos),
            publicGists: Int(user.publicGists),
            location: user.location)
        return userModel
    }
}
