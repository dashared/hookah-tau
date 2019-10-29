//
//  ProfileChangeCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 19/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

enum EditingOption {
    case name, phone, invite
}

class ProfileChangeCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var changeModel: ChangeModel?
    
    // MARK: - Lifecycle
    
    override func start() {
        let changeViewController = ProfileChangeViewController()
        changeViewController.coordinator = self
        changeViewController.changeModel = changeModel
        changeViewController.modalPresentationStyle = .popover
        navigationController?.present(changeViewController, animated: true)
    }
    
    /// Done
    func update(withModel model: User) {
        for controller in navigationController?.viewControllers ?? [] {
            guard let updatableController = controller as? UserUpdate else { continue }
            updatableController.updateUser(withModel: model)
        }
        
        didEndFlow?()
    }
    
    /// Cancel
    func discardChange() {
        didEndFlow?()
    }
}
