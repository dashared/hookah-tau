//
//  AuthCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AuthCoordinator: BaseCoordinator {

    override func start() {
        let authViewController = AuthViewController()
        authViewController.coordinator = self
        navigationController?.viewControllers = [ authViewController ]
    }

    func goToNextStep() {
        let codeCoordinator = CodeCoordinator(navigationController: navigationController)
        addDependency(codeCoordinator)
        codeCoordinator.start()
    }
}
