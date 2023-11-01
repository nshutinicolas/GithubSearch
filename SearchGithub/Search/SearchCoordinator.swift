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
        navigationController.setViewControllers([viewController], animated: true)
    }
}
