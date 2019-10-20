//
//  NameCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class PhoneCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var didEndFlow: (() -> Void)?

    override func start() {
        let phoneVC = PhoneNumberViewController()
        phoneVC.coordinator = self
        navigationController?.viewControllers = [ phoneVC ]
    }
    
    func goToNextStep() {
        let codeCoordinator = CodeCoordinator(navigationController: navigationController)
        codeCoordinator.didEndFlow = { [weak self] in self?.didEndFlow?() }
        codeCoordinator.parentCoordinator = self
        addDependency(codeCoordinator)
        codeCoordinator.start()
    }
}
