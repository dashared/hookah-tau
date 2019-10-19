//
//  ProfileChangeCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 19/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class ProfileChangeCoordinator: BaseCoordinator {
    override func start() {
        let changeViewController = ProfileChangeViewController()
        changeViewController.modalPresentationStyle = .popover
        navigationController?.present(changeViewController, animated: true)
    }
    
    /// Done
    func doneChanging() {
        
    }
    
    /// Cancel
    func discardChange() {
        
    }
}
