//
//  ProfileCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ProfileCoordinator: BaseCoordinator {
    override func start() {
        let profileViewController = ProfileViewController()
        navigationController?.viewControllers = [profileViewController]
    }
}
