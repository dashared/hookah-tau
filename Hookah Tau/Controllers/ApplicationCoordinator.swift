//
//  File.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ApplicationCoordinator: BaseCoordinator {

    var launch: LaunchOptions?

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
        self.launch = LaunchOptions.configure()
    }

    private func runAuthFlow() {
        let phoneCoordinator = PhoneCoordinator(navigationController: navigationController)
        phoneCoordinator.didEndFlow = { [weak self] in
            self?.launch = LaunchOptions.main // TESTING
            self?.start()
            self?.removeDependency(phoneCoordinator)
        }
        addDependency(phoneCoordinator)
        phoneCoordinator.start()
    }

    private func runAdminFlow() {

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
            print("configuring...")
            return .auth
        }
    }
}
