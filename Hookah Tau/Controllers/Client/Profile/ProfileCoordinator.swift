//
//  ProfileCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

protocol UserUpdate: class {
    func updateUser(withModel model: User)
}

class ProfileCoordinator: BaseCoordinator {
    
    override func start() {
        let profileViewController = ProfileClientViewController()
        profileViewController.coordinator = self
        navigationController?.viewControllers = [profileViewController]
    }
    
    func presentEditMode(withModel model: ChangeModel) {
        let changeCoordinator = ProfileChangeCoordinator(navigationController: navigationController)
        changeCoordinator.changeModel = model
        changeCoordinator.didEndFlow = {
            [weak self] in
            self?.navigationController?.dismiss(animated: true)
            self?.removeDependency(changeCoordinator)
        }
        addDependency(changeCoordinator)
        changeCoordinator.start()
    }
    
    func logout() {
        DataStorage.standard.setLoggedInState(false)
        didEndFlow?()
    }
}
