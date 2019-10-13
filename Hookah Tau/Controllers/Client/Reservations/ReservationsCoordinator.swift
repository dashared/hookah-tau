//
//  ReservationsCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationsCoordinator: BaseCoordinator {
    override func start() {
        let reservationsViewController = ReservationsViewController()
        navigationController?.viewControllers = [reservationsViewController]
    }
}
