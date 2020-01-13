//
//  AdminReservationsCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminReservationsCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var establishmentId: Int?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "AdminReservations", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdminReservationsController") as! AdminReservationsController
        vc.id = establishmentId
        vc.coordinator = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
    
    /// Сюда мы идем после нажатия кнопочки "Забронировать" или плюсика справа сверху
    func book(inEstablishment establishmentId: Int) {
        let reservationCoordinator = AdminFirstStepReservationViewCoordinator(navigationController: navigationController)
        reservationCoordinator.establishment = establishmentId
        addDependency(reservationCoordinator)
        reservationCoordinator.didFinish = { [weak self] in
            self?.removeDependency(reservationCoordinator)
            self?.navigationController?.popViewController(animated: true)
        }
        
        reservationCoordinator.start()
    }
}
