//
//  AddressCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 25/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AddressCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var didFinish: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func start() {
        let addressViewController = AddresViewController()
        addressViewController.coordinator = self
        navigationController?.pushViewController(addressViewController, animated: true)
    }
    
    /// cancel reservation process
    func goBack() {
        didFinish?()
    }
    
    /// continue with reservation
    /// TODO: pass some data
    func chooseTableAndTime(inEstablishment id: Int) {
        let reservationCoordinator = FirstStepReservationCoordinator(navigationController: navigationController)
        reservationCoordinator.establishment = id
        
        addDependency(reservationCoordinator)
        reservationCoordinator.didFinish = { [weak self] in
            self?.removeDependency(reservationCoordinator)
            self?.navigationController?.popViewController(animated: false)
            self?.didFinish?()
        }
        
        reservationCoordinator.start()
    }
}
