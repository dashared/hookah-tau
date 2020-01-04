//
//  ClientProfileCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class ClientProfileCoordinator: BaseCoordinator {
    
    var user: FullUser?
    
    override func start() {
        let storyboard = UIStoryboard(name: "ClientList", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileTableViewController") as? ProfileTableViewController
        viewController?.user = user
        guard let vc = viewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // Создание бронирования из профиля клиента
    func createReservation(forUserWithPhone phoneNumber: String) {
        
    }
}
