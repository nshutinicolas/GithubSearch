//
//  GitUserProfileCoordinator.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import UIKit

class GitUserProfileCoordinator: BaseCoordinator {
    func start() {
        let viewController = GitUserProfileViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
