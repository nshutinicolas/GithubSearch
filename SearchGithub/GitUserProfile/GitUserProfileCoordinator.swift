//
//  GitUserProfileCoordinator.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 01/11/2023.
//

import UIKit

class GitUserProfileCoordinator: BaseCoordinator {
    func start(with user: GitUserModel) {
        let viewController = GitUserProfileViewController()
        viewController.user.accept(user)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToEngagement(for user: GitUserModel, engagement: QueryBuilder.UserPath) {
        let engagementCoordinator = EngagementCoordinator(navigationController: navigationController)
        children.append(engagementCoordinator)
        engagementCoordinator.start(with: user, engegement: engagement)
    }
}
