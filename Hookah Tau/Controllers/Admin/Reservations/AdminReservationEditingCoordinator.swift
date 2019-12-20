//
//  AdminReservationEditingCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 20/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class AdminReservationEditingCoordinator: BaseCoordinator {
    
    // MARK: - Peoperties
    
    var reservationData: ReservationWithUser?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "AdminReservations", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdminReservationEditingViewController") as! AdminReservationEditingViewController
        vc.reservationData = reservationData
        vc.coordinator = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
