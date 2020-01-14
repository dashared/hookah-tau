//
//  AdminSecondStepReservationViewCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 13/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminSecondStepReservationViewCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var didFinish: (() -> Void)?
    
    var map: MapImageScroll?
    
    var model: SecondStepModel?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "AdminReservations", bundle: nil)
        let reservationVC = storyboard.instantiateViewController(withIdentifier: "AdminSecondStepReservationViewController") as! AdminSecondStepReservationViewController
        reservationVC.mapScrollView = map
        reservationVC.coordinator = self
        navigationController?.pushViewController(reservationVC, animated: true)
    }
    
    func continueReservation(with user: FullUser?, phone phoneNumber: String) {
        let finalStepCoordinator = AdminFinalStepReservationCoordinator(navigationController: navigationController)
        finalStepCoordinator.model = self.model
        
        addDependency(finalStepCoordinator)
        finalStepCoordinator.didFinish = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
            self?.removeDependency(finalStepCoordinator)
            self?.didFinish?()
        }
        
        if let u = user {
            finalStepCoordinator.user = u
        } else {
            finalStepCoordinator.user = FullUser(uuid: nil,
                                                 name: nil,
                                                 phoneNumber: phoneNumber,
                                                 isAdmin: true)
        }
        
        finalStepCoordinator.start()
    }
}
