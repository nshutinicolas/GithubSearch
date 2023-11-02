//
//  SearchCoordinator.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import UIKit

class SearchCoordinator: BaseCoordinator {
    
    func start() {
        let viewController = SearchViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func navigateToProfile(of user: GitUserModel) {
        let userProfileCoordinator = GitUserProfileCoordinator(navigationController: navigationController)
        children.append(userProfileCoordinator)
        userProfileCoordinator.start(with: user)
    }
}
