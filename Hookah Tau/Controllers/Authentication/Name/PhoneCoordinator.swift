//
//  NameCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class PhoneCoordinator: BaseCoordinator {
    weak var parentCoordinator: NameCoordinator?

    override func start() {
        let phoneVC = PhoneNumberViewController()
        phoneVC.coordinator = self
        navigationController?.pushViewController(phoneVC, animated: true)
    }
    
    func goToNextStep() {
        let codeCoordinator = CodeCoordinator(navigationController: navigationController)
        addDependency(codeCoordinator)
        codeCoordinator.start()
    }

    func goBack() {
        parentCoordinator?.removeDependency(self)
    }
}
