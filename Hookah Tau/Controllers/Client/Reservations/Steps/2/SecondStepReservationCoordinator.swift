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
    
    var didFinish: (() -> Void)?
    
    var goBack: ((MapImageScroll?) -> Void)?
    
    var model: SecondStepModel?
    
    var mapView: MapImageScroll?
    
    var onBooking: ((MapImageScroll, Reservation) -> Void)?
    
    var vc: SecondStepReservationViewController?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "SecondStepReservationViewController") as? SecondStepReservationViewController
        
        guard let viewController = vc else { return }
        
        viewController.model = model
        viewController.mapView = mapView
        viewController.coordinator = self
        
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func cancel(_ mapView: MapImageScroll?) {
        goBack?(mapView)
    }
    
    func book(_ mapView: MapImageScroll?, reservation: Reservation) {
        let coordinator = ThirdStepReservationCoordinator(navigationController: navigationController)
        addDependency(coordinator)
        
        coordinator.didFinish = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
            self?.removeDependency(coordinator)
            self?.didFinish?()
        }
        
        coordinator.mapView = mapView
        coordinator.resrvation = reservation
        
        coordinator.start()
    }
}
