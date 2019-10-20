//
//  AuthCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class NameCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var didEndFlow: (() -> Void)?
    
    var parentCoordinator: CodeCoordinator?

    override func start() {
        let nameViewController = NameViewController()
        nameViewController.coordinator = self
        navigationController?.pushViewController(nameViewController, animated: true)
    }

    func goToNextStep() {
        print("Did end auth flow...")
        didEndFlow?()
    }
    
    func goBack() {
        parentCoordinator?.removeDependency(self)
        navigationController?.popViewController(animated: true)
    }
}
