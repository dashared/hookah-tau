//
//  AdminFirstStepReservationViewCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 13/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import UIKit

enum UserType {
    case admin
    case client
}

protocol FirstStepReservationProtocol: BaseCoordinator {
    
    var user: UserType { get }
    
    func makeReservation(model: SecondStepModel, mapView: MapImageScroll?)
}

class AdminFirstStepReservationViewCoordinator: BaseCoordinator{
    
    // MARK: - Properties
    
    var didFinish: (() -> Void)?
    
    var establishment: Int = 1
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        let reservationVC = storyboard.instantiateViewController(withIdentifier: "ReservationViewController") as! FirstStepReservationViewController
        
        reservationVC.coordinator = self
        reservationVC.establishmentId = establishment
        
        navigationController?.pushViewController(reservationVC, animated: true)
    }
    
    
}

extension AdminFirstStepReservationViewCoordinator: FirstStepReservationProtocol {
    
    var user: UserType {
        get {
            return .admin
        }
    }
   
    func makeReservation(model: SecondStepModel, mapView: MapImageScroll?) {
        let reservationCoordinaotor = AdminSecondStepReservationViewCoordinator(navigationController: navigationController)
        reservationCoordinaotor.model = model
        reservationCoordinaotor.map = mapView
        
        addDependency(reservationCoordinaotor)
        reservationCoordinaotor.didFinish = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
            self?.removeDependency(reservationCoordinaotor)
            self?.didFinish?()
        }
        
        reservationCoordinaotor.start()
    }
}

