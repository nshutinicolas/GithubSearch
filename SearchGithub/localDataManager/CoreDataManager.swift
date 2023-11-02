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
//    let modelName = "GitUser"
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    init(modelName: String = "LocalDataManager") {
        persistentContainer = NSPersistentContainer(name: modelName)
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
    func createGitUser(_ user: GitUserModel) {
        let userContext = GitUser(context: viewContext)
        userContext.id = Int16(user.id)
        userContext.name = user.name ?? ""
        userContext.login = user.login
        userContext.bio = user.bio ?? ""
        userContext.avatarUrl = user.avatarUrl
        userContext.url = user.url
        userContext.followersUrl = user.followersUrl
        userContext.followingUrl = user.followingUrl
        userContext.reposUrl = user.reposUrl
        userContext.followers = Int16(user.followers ?? 0)
        userContext.following = Int16(user.following ?? 0)
        userContext.publicRepos = Int16(user.publicRepos ?? 0)
        userContext.publicGists = Int16(user.publicGists ?? 0)
        userContext.location = user.location ?? ""
        
        // Save the User
        save()
    }
    // TODO: Create a better transformer for this
    // Create GitUserModel method
    func createGitUserModel(_ user: GitUser) -> GitUserModel {
        var userModel = GitUserModel(
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
    
    // TODO: Make this method a throwing method to handle errors
    func fetchUsers() -> [GitUserModel] {
        let request: NSFetchRequest<GitUser> = GitUser.fetchRequest()
        // TODO: Perform a sorting method
        
        let storedUsers = try? viewContext.fetch(request)
        
        var userModel: [GitUserModel] = []
        storedUsers?.forEach { userModel.append(createGitUserModel($0)) }
        return userModel
    }
}
