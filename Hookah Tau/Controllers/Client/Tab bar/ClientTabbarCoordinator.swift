//
//  TabbarCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 21/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ClientTabbarCoordinator: BaseCoordinator {
    
    typealias TabbarClosure = ((UINavigationController) -> ())
    
    // MARK: - Lifecycle
    
    override func start() {
        let storyboard = UIStoryboard(name: "Client", bundle: nil)
        let tabbarView = storyboard.instantiateViewController(withIdentifier: "ClientTabbarController") as? ClientTabbarController
        
        tabbarView?.onViewDidLoad = runReservationsFlow()
        tabbarView?.onProfileFlowSelect = runProfileFlow()
        tabbarView?.onReservationFlowSelect = runReservationsFlow()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let appD = appDelegate else { return }
        appD.window?.rootViewController = tabbarView
    }
    
    private func runReservationsFlow() -> TabbarClosure {
        return { [unowned self] navigationController in
            if navigationController.viewControllers.isEmpty {
                let reservationsCoordinator = ReservationsCoordinator(navigationController: navigationController)
                self.addDependency(reservationsCoordinator)
                reservationsCoordinator.start()
            }
        }
    }
    
    private func runProfileFlow() -> TabbarClosure{
        return { navigationController in
            if navigationController.viewControllers.isEmpty {
                let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
                self.addDependency(profileCoordinator)
                profileCoordinator.start()
            }
        }
    }
}
