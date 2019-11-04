//
//  NameCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class PhoneCoordinator: BaseCoordinator {
    
    // MARK: - Lifecycle

    override func start() {
        let phoneVC = PhoneNumberViewController()
        phoneVC.coordinator = self
        navigationController?.viewControllers = [ phoneVC ]
    }
    
    /// Method chooses next step. Depends on weather user was previously registered
    /// - Parameter isUserRegistered: was user registered
    func goToNextStep(isUserRegistered: Bool) {
        let coordinator: BaseCoordinator!
        
        if isUserRegistered {
            coordinator = CodeCoordinator(navigationController: navigationController)
        } else {
            coordinator = NameCoordinator(navigationController: navigationController)
        }
        
        coordinator.didEndFlow = { [weak self] in self?.didEndFlow?() }
        coordinator.parentCoordinator = self
        addDependency(coordinator)
        coordinator.start()
    }
}
