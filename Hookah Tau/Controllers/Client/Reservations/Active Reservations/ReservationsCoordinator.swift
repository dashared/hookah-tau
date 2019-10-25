//
//  ReservationsCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationsCoordinator: BaseCoordinator {
    
    // MARK: - Lifecycle
    
    override func start() {
        let reservationsViewController = ReservationsViewController()
        reservationsViewController.coordinator = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.viewControllers = [reservationsViewController]
    }
    
    /// Start process of creating reservation
    func makeReservation() {
        let addressCoordinator = AddressCoordinator(navigationController: navigationController)
        addDependency(addressCoordinator)
        addressCoordinator.didFinish = { [weak self] in
            self?.removeDependency(addressCoordinator)
            self?.navigationController?.popViewController(animated: true)
        }
        addressCoordinator.start()
    }
}
