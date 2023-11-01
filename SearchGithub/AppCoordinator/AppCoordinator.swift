//
//  AppCoordinator.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import UIKit

@objc protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    @objc optional func start()
}

class BaseCoordinator: Coordinator {
    var children: [Coordinator]
    var navigationController: UINavigationController
    init(navigationController: UINavigationController, children: [Coordinator] = []) {
        self.children = children
        self.navigationController = navigationController
    }
}

class AppCoordinator {
    static private(set) var shared: AppCoordinator?
    
    public private(set) var navigationController: UINavigationController
    weak var window: UIWindow?
    init(window: UIWindow?) {
        self.window = window
        self.navigationController = .init()
        AppCoordinator.shared = self
    }
    
    func start() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        searchCoordinator.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
