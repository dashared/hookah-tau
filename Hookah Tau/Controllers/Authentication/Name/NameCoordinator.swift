//
//  AuthCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class NameCoordinator: BaseCoordinator {
    
    // MARK: - Lifecycle

    override func start() {
        let nameViewController = NameViewController()
        nameViewController.coordinator = self
        navigationController?.pushViewController(nameViewController, animated: true)
    }

    func goToNextStep(withName name: String) {
        let codeCoordinator = CodeCoordinator(navigationController: navigationController)
        codeCoordinator.userName = name
        codeCoordinator.didEndFlow = { [weak self] in self?.didEndFlow?() }
        codeCoordinator.parentCoordinator = self
        addDependency(codeCoordinator)
        codeCoordinator.start()
    }
    
    func goBack() {
        parentCoordinator?.removeDependency(self)
        navigationController?.popViewController(animated: true)
    }
}
