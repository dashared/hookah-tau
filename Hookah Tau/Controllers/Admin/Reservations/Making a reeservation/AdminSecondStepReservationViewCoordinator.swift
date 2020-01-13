//
//  AdminSecondStepReservationViewCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 13/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminSecondStepReservationViewCoordinator: BaseCoordinator {
    
    var map: MapImageScroll?
    
    override func start() {
        let storyboard = UIStoryboard(name: "AdminReservations", bundle: nil)
        let reservationVC = storyboard.instantiateViewController(withIdentifier: "AdminSecondStepReservationViewController") as! AdminSecondStepReservationViewController
        reservationVC.mapScrollView = map
        reservationVC.coordinator = self
        navigationController?.pushViewController(reservationVC, animated: true)
    }
    
    func continueReservation() {
        let editingCoordinator = AdminReservationEditingCoordinator(navigationController: navigationController)
        editingCoordinator.start()
    }
}
