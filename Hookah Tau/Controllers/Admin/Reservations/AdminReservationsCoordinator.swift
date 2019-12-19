//
//  AdminReservationsCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminReservationsCoordinator: BaseCoordinator {
    
    var establishmentId: Int?
    
    override func start() {
        let storyboard = UIStoryboard(name: "AdminReservations", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdminReservationsController") as! AdminReservationsController
        vc.id = establishmentId
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
