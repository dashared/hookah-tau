//
//  AdminTabbarCoordinator.swift
//  Hookah Tau
//
//  Created by cstore on 05/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class AdminTabbarCoordinator: BaseCoordinator {
    
    /// Мы тут определяем что происходит с таббарами
    override func start() {
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        let tabbarView = storyboard.instantiateViewController(withIdentifier: "AdminTabbarController") as? AdminTabbarController
        
        tabbarView?.onViewDidLoad = runReservationsFlow()
        tabbarView?.onClientsFlow = runClientsFlow()
        tabbarView?.onProfileFlow = runProfileFlow()
        tabbarView?.onReservationsFlow = runReservationsFlow()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let appD = appDelegate else { return }
        appD.window?.rootViewController = tabbarView
    }
    
    private func runReservationsFlow() -> TabbarClosure {
        print("reserv")
        return { [unowned self] navigationController in
            if navigationController.viewControllers.isEmpty {
                
            }
        }
    }
    
    private func runClientsFlow() -> TabbarClosure {
        print("client")
        return { [unowned self] navigationController in
            if navigationController.viewControllers.isEmpty {
                
            }
        }
    }
    
    private func runProfileFlow() -> TabbarClosure {
        print("prof")
        return { [unowned self] navigationController in
            if navigationController.viewControllers.isEmpty {
                
            }
        }
    }
    
}
