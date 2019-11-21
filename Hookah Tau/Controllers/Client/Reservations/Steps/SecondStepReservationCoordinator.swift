//
//  SecondStepReservationCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 21/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class SecondStepReservationCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var didFinish: ((MapImageScroll?) -> Void)?
    
    var model: SecondStepModel?
    
    var mapView: MapImageScroll?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        let reservationVC = storyboard.instantiateViewController(withIdentifier: "SecondStepReservationViewController") as! SecondStepReservationViewController
        
        reservationVC.model = model
        reservationVC.mapView = mapView
        reservationVC.coordinator = self
        
        navigationController?.pushViewController(reservationVC, animated: false)
    }
    
    func cancel(_ mapView: MapImageScroll?) {
        didFinish?(mapView)
    }
}
