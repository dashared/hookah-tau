//
//  ClientProfileCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class ClientProfileCoordinator: BaseCoordinator {
    
    var user: Client?
    
    override func start() {
        let storyboard = UIStoryboard(name: "ClientList", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileTableViewController") as? ProfileTableViewController
        viewController?.user = user
        viewController?.coodinator = self
        guard let vc = viewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // Создание бронирования из профиля клиента
    func createReservation(forUserWithPhone phoneNumber: String, user fullUser: FullUser) {
        let coordinator = AdminFirstStepReservationViewCoordinator(navigationController: navigationController)
        coordinator.phone = phoneNumber
        coordinator.fullUser = fullUser
        
        addDependency(coordinator)
        coordinator.didFinish = { [weak self] in
            self?.removeDependency(coordinator)
            self?.navigationController?.popViewController(animated: true)
        }
        
        coordinator.start()
    }
    
    // Просмотр (и редактирование) брони
    func seeExistingReservation(data: ReservationWithUser) {
        let reservationCoordinator = AdminReservationEditingCoordinator(navigationController: navigationController)
        addDependency(reservationCoordinator)
        reservationCoordinator.reservationData = data
        reservationCoordinator.didEndFlow = { [weak self] in
            self?.removeDependency(reservationCoordinator)
            self?.navigationController?.popViewController(animated: true)
        }
        reservationCoordinator.start()
    }
}
