//
//  ClientsCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 09/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class ClientsCoordinator: BaseCoordinator {
    
    override func start() {
        let storyboard = UIStoryboard(name: "ClientList", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ClientsViewController") as? ClientsViewController
        
        guard let vc = viewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// TODO
    func openUserProfile(withUUID uuid: String) {
        
    }
}
