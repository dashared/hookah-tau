//
//  AdminFinalStepReservationCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 14/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import UIKit

protocol ShowReservationCoordinator: BaseCoordinator {
    var didFinish: (() -> Void)? { get }
}

class AdminFinalStepReservationCoordinator: BaseCoordinator, ShowReservationCoordinator {
    
    // MARK: - Properties
    
    var didFinish: (() -> Void)?
    
    var user: FullUser?
    
    var model: SecondStepModel?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "AdminReservations", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdminReservationEditingViewController") as! AdminReservationEditingViewController
        
        guard
            let model = model,
            let u = user else { return }
        vc.reservationData = ReservationWithUser(uuid: nil,
                                                 establishment: model.establishment,
                                                 startTime: model.startTime,
                                                 endTime: model.startTime.addHours(2),
                                                 numberOfGuests: 2,
                                                 reservedTable: model.table,
                                                 owner: u)
        
        vc.reservedPeriods = model.reservedintervals
        vc.coordinator = self

        navigationController?.pushViewController(vc, animated: true)
    }
}
