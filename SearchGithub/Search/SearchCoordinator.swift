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
    
    func navigateToProfile() {
        let coordinator = GitUserProfileCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
