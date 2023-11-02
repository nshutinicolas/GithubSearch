//
//  EngagementCoordinator.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 02/11/2023.
//

import UIKit

class EngagementCoordinator: BaseCoordinator {
    func start(with user: GitUserModel, engegement: QueryBuilder.UserPath) {
        let viewController = EngagementViewController(with: user, engagement: engegement)
        viewController.coordinator = self
        navigationController.present(viewController, animated: true)
    }
}
