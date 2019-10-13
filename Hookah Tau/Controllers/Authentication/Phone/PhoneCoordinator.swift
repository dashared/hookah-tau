//
//  NameCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class PhoneCoordinator: BaseCoordinator {
    
    var didEndFlow: (() -> Void)?
    
    weak var parentCoordinator: NameCoordinator?

    override func start() {
        let phoneVC = PhoneNumberViewController()
        phoneVC.coordinator = self
        navigationController?.pushViewController(phoneVC, animated: true)
    }
    
    func goToNextStep() {
        let codeCoordinator = CodeCoordinator(navigationController: navigationController)
        codeCoordinator.didEndFlow = { [weak self] in self?.didEndFlow?() }
        addDependency(codeCoordinator)
        codeCoordinator.start()
    }

    func goBack() {
        parentCoordinator?.removeDependency(self)
        navigationController?.popViewController(animated: true)
    }
}
