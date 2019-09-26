//
//  NameCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class NameCoordinator: BaseCoordinator {
    weak var parentCoordinator: CodeCoordinator?

    override func start() {
        let nameVC = NameViewController()
        nameVC.coordinator = self
        navigationController?.pushViewController(nameVC, animated: true)
    }

    func goBack() {
        parentCoordinator?.removeDependency(self)
    }
}
