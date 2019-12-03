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
    
    var didFinish: (() -> Void)?
    
    var mapView: MapImageScroll?
    
    /// Объект регистрации, созданной или существующей
    var resrvation: Reservation?
    
    var reservationVC: ThirdStepReservationViewController?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        reservationVC = storyboard.instantiateViewController(withIdentifier: "ThirdStepReservationViewController") as? ThirdStepReservationViewController
        
        reservationVC?.coordinator = self
        reservationVC?.mapView = mapView
        reservationVC?.reservation = resrvation
        
        guard let r = reservationVC else { return }
        navigationController?.pushViewController(r, animated: false)
    }
    
    /// You need to pass reservation object and map describing booked table
    func change(_ reservation: Reservation, _ map: MapImageScroll) {
        let changeCoordinator = ChangeReservationCoordinator(navigationController: navigationController)
        
        changeCoordinator.reservation = reservation
        changeCoordinator.map = map
        
        changeCoordinator.didFinish = { [weak self] res in
            self?.removeDependency(changeCoordinator)
            self?.navigationController?.popViewController(animated: false)
            self?.reservationVC?.reservation = res
        }
        
        changeCoordinator.start()
    }
    
    /// Goes back to `allReservations` screen
    func close() {
        didFinish?()
    }
}
