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
    
    var didFinish: ((MapImageScroll?) -> Void)?
    
    var mapView: MapImageScroll?
    
    /// Объект регистрации, созданной или существующей
    var resrvation: Reservation?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        let reservationVC = storyboard.instantiateViewController(withIdentifier: "ThirdStepReservationViewController") as! ThirdStepReservationViewController
        
        reservationVC.coordinator = self
        reservationVC.mapView = mapView
        reservationVC.reservation = resrvation
        
        navigationController?.pushViewController(reservationVC, animated: false)
    }
    
    /// You need to pass reservation object and map describing booked table
    func change(_ reservation: Reservation, _ map: MapImageScroll) {
        //
    }
    
    /// Goes back to `allReservations` screen
    func close() {
        didFinish?(nil)
    }
}
