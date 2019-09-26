//
//  InputCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class CodeCoordinator: BaseCoordinator {

    weak var parentCoordinator: AuthCoordinator?

    override func start() {
        let smsInput = CodeViewController()
        smsInput.coordinator = self
        navigationController?.pushViewController(smsInput, animated: true)
    }

    func goToNextStep() {
        let nameCoordinator = NameCoordinator(navigationController: navigationController)
        addDependency(nameCoordinator)
        nameCoordinator.start()
    }

    func goBack() {
        parentCoordinator?.removeDependency(self)
    }

}
