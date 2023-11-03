//
//  CoreDataManager.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 02/11/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    private init() {
        persistentContainer = NSPersistentContainer(name: "LocalDataManager")
    }
    
    func loadStore() {
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                // TODO: Handle this error
                print("Failed to load store; \(error.localizedDescription)")
                return
            }
            print("Store loaded")
        }
    }
    /// Boiler plate
    // Create GitUser method - Returning method for some some tests
    func saveGitUser(_ user: GitUserModel) {
        let userContext = GitUser(context: viewContext)
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
        
        // Save the User
        save()
    }
    // TODO: Create a better transformer for this
    // Create GitUserModel method
    func createGitUserModel(_ user: GitUser) -> GitUserModel {
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
    
    func save() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            // TODO: Handle saving error
            print("Failed to save user with: \(error.localizedDescription)")
        }
    }
    
    // TODO: Make this method generic to handle other types
    func fetchUsers() throws -> [GitUserModel] {
        let request: NSFetchRequest<GitUser> = GitUser.fetchRequest()
        // TODO: Perform a sorting method
        let storedUsers = try viewContext.fetch(request)
        var userModel: [GitUserModel] = []
        storedUsers.forEach { userModel.append(createGitUserModel($0)) }
        return userModel
    }
    
    // TODO: Possibility of enum keys - Look into it
    /// Making this more generic would help - extract the underlying predicate
    /// Tempory to get the job done for now
    func fetchUser(with key: String, value: String) throws -> GitUserModel? {
        let request: NSFetchRequest<GitUser> = GitUser.fetchRequest()
        request.fetchLimit = 1
        let searchPredicate = NSPredicate(format: "\(key) == %@", value)
        request.predicate = searchPredicate
        let storedUser = try viewContext.fetch(request).first
        // Possibility of returning nil - Look into generic implementation
        guard let storedUser else { return nil }
        return createGitUserModel(storedUser)
    }
}
