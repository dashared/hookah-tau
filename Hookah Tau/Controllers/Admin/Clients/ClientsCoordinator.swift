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
        viewController?.coordinator = self
        guard let vc = viewController else { return }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.viewControllers = [vc]
    }
    
    /// TODO
    func openUserProfile(_ profile: FullUser) {
        let profileCoordinator = ClientProfileCoordinator(navigationController: navigationController)
        profileCoordinator.user = profile
        
        self.addDependency(profileCoordinator)
        profileCoordinator.didEndFlow = {
            self.removeDependency(profileCoordinator)
            self.navigationController?.popViewController(animated: true)
        }
        
        profileCoordinator.start()
    }
}
