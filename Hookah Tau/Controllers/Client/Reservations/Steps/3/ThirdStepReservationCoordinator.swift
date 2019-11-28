//
//  ThirdStepReservationCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 23/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ThirdStepReservationCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var didFinish: ((MapImageScroll) -> Void)?
    
    /// callback to change created booking
    var wantsToBeChanged: ((Reservation) -> Void)?
    
    var mapView: UIView?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        let reservationVC = storyboard.instantiateViewController(withIdentifier: "ThirdStepReservationViewController") as! ThirdStepReservationViewController
        
        reservationVC.coordinator = self
    
        
        navigationController?.pushViewController(reservationVC, animated: false)
    }
    
    /// You need to pass `uuid` of the booking to be changed
    func change(_ reservation: Reservation) {
        wantsToBeChanged?(reservation)
    }
}
