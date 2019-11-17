//
//  ReservationCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var didFinish: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        let reservationVC = storyboard.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController
        
        navigationController?.pushViewController(reservationVC, animated: true)
    }
    
    func callAdmin() {
        
    }
    
    // TODO: with parameters
    func makeReservation() {
        
    }
}
