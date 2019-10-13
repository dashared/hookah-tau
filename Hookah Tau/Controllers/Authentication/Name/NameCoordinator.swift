//
//  AuthCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class NameCoordinator: BaseCoordinator {
    
    var didEndFlow: (() -> Void)?

    override func start() {
        let nameViewController = NameViewController()
        nameViewController.coordinator = self
        navigationController?.viewControllers = [ nameViewController ]
    }

    func goToNextStep() {
        let phoneCoordinator = PhoneCoordinator(navigationController: navigationController)
        phoneCoordinator.didEndFlow = { [weak self] in self?.didEndFlow?() }
        addDependency(phoneCoordinator)
        phoneCoordinator.start()
    }
}
