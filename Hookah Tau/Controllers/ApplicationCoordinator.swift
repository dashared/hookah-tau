//
//  File.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ApplicationCoordinator: BaseCoordinator {

    var launch: LaunchOptions? {
        return LaunchOptions.configure()
    }

    override func start() {
        guard let launch = launch else { return }

        switch launch {
        case .admin:
            runAdminFlow()
        case .main:
            runClientFlow()
        case .auth:
            runAuthFlow()
        }
    }

    required init(navigationController: UINavigationController?) {
        super.init(navigationController: navigationController)
    }

    private func runAuthFlow() {
        let phoneCoordinator = PhoneCoordinator(navigationController: navigationController)
        phoneCoordinator.didEndFlow = { [weak self] in
            self?.start()
            self?.removeDependency(phoneCoordinator)
        }
        addDependency(phoneCoordinator)
        phoneCoordinator.start()
    }

    private func runAdminFlow() {
        let tabbarCoordinator = AdminTabbarCoordinator(navigationController: navigationController)
        tabbarCoordinator.didEndFlow = { [weak self, weak tabbarCoordinator] in
            self?.start()
            self?.removeDependency(tabbarCoordinator)
        }
        addDependency(tabbarCoordinator)
        tabbarCoordinator.start()
    }

    private func runClientFlow() {
        let tabBarCoordinator = ClientTabbarCoordinator(navigationController: nil)
        tabBarCoordinator.didEndFlow = { [weak self, weak tabBarCoordinator] in
            self?.start()
            self?.removeDependency(tabBarCoordinator)
        }
        addDependency(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}

// MARK: - Nested types
extension ApplicationCoordinator {
    enum LaunchOptions {
        case auth, admin, main

        static func configure() -> LaunchOptions {
            let isAuthorized = DataStorage.standard.isLoggedIn()
            let isAdmin = DataStorage.standard.getUserModel()?.isAdmin ?? false
            
            if !isAuthorized {
                return .auth
            }
            
            if isAdmin {
                return .admin
            }
            
            return .main
        }
    }
}
