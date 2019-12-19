//
//  AdminAddressCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 09/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class AdminAddressCoordinator: BaseCoordinator {
    
    override func start() {
        let addressViewController = AddresViewController()
        addressViewController.coordinator = self
        navigationController?.viewControllers = [addressViewController]
        
        guard let id = DataStorage.standard.getEstablishmentChoice() else { return }
        openReservations(forEstablishment: id)
    }
    
    private func openReservations(forEstablishment id: Int) {
        let reservationsCoordinator = AdminReservationsCoordinator(navigationController: navigationController)
        reservationsCoordinator.establishmentId = id
        reservationsCoordinator.start()
    }
}

extension AdminAddressCoordinator: AddressMapper {
    func chooseAddress(establishmentId id: Int) {
        DataStorage.standard.setupEstablishmentChoice(id: id)
        openReservations(forEstablishment: id)
    }
}
