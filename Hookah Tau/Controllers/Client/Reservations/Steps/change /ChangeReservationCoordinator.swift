//
//  ChangeReservationCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 02/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ChangeReservationCoordinator: BaseCoordinator {
    
    // MARK: - Peoperties
    
    var reservation: Reservation?
    
    var map: MapImageScroll?
    
    var didFinish: ((Reservation) -> Void)?
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Reservation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangeReservationViewController") as? ChangeReservationViewController
        
        guard let viewController = vc else { return }
        
        viewController.reservation = reservation
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    /// Закончили редактирование, все хорошо
    func finish(_ r: Reservation) {
        didFinish?(r)
    }
}
