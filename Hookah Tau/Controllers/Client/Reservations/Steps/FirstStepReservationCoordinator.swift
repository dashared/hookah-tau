//
//  ReservationCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class FirstStepReservationCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var didFinish: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        let reservationVC = storyboard.instantiateViewController(withIdentifier: "ReservationViewController") as! FirstStepReservationViewController
        
        reservationVC.coordinator = self
        navigationController?.pushViewController(reservationVC, animated: true)
    }
    
    func callAdmin() {
        
    }
    
    func makeReservation(model: SecondStepModel,
                         mapView: MapImageScroll?) {
        
        let reservationCoordinator =
            SecondStepReservationCoordinator(navigationController: navigationController)
        
        reservationCoordinator.model = model
        reservationCoordinator.mapView = mapView
        
        addDependency(reservationCoordinator)
        
        reservationCoordinator.didFinish = { [weak self] mapView in
            
            self?.navigationController?.popViewController(animated: false)
            self?.removeDependency(reservationCoordinator)
            if let vv = self?.navigationController?.topViewController as? FirstStepReservationViewController {
                vv.mapView = mapView
            }
        }
        
        reservationCoordinator.start()
    }
}
