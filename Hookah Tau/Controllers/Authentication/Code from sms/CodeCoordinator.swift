//
//  InputCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class CodeCoordinator: BaseCoordinator {
    
    var didEndFlow: (() -> Void)?

    weak var parentCoordinator: PhoneCoordinator?

    override func start() {
        let smsInput = CodeSmsViewController()
        smsInput.coordinator = self
        navigationController?.pushViewController(smsInput, animated: true)
    }

    func goBack() {
        parentCoordinator?.removeDependency(self)
        navigationController?.popViewController(animated: true)
    }
    
    func goToNextStep() {
        print("Did end auth flow...")
        didEndFlow?()
    }

}
