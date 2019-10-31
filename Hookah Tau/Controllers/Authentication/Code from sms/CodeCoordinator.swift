//
//  InputCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class CodeCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var userName: String?

    override func start() {
        let smsInput = CodeSmsViewController()
        smsInput.userName = userName
        smsInput.coordinator = self
        navigationController?.pushViewController(smsInput, animated: true)
    }

    func goBack() {
        parentCoordinator?.removeDependency(self)
        navigationController?.popViewController(animated: true)
    }
    
    /// Last step of authorization process
    func goToNextStep() {
        print("Did end auth flow...")
        didEndFlow?()
    }
}
