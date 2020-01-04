//
//  AdminTabbarController.swift
//  Hookah Tau
//
//  Created by cstore on 05/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminTabbarController: UITabBarController {
    
    // MARK: - Properties
    
    var onViewDidLoad: TabbarClosure?
    var onReservationsFlow: TabbarClosure?
    var onClientsFlow: TabbarClosure?
    var onProfileFlow: TabbarClosure?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        if let controller = customizableViewControllers?.first as? UINavigationController {
            onViewDidLoad?(controller)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        
        switch selectedIndex {
        case 0:
            onReservationsFlow?(controller)
        case 1:
            onClientsFlow?(controller)
        default:
            onProfileFlow?(controller)
        }
    }

}

extension AdminTabbarController: UITabBarControllerDelegate {}
