//
//  TabbarController.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 21/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation
import UIKit

protocol TabbarView: class {
    var onReservationFlowSelect: TabbarClosure? { get set }
    var onProfileFlowSelect: TabbarClosure? { get set }
    var onViewDidLoad: TabbarClosure? { get set }
}

final class ClientTabbarController: UITabBarController, UITabBarControllerDelegate, TabbarView {
    
    // MARK: - Properties
    
    var onReservationFlowSelect: TabbarClosure?
    var onProfileFlowSelect: TabbarClosure?
    var onViewDidLoad: TabbarClosure?
    
    
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
        
        if selectedIndex == 0 {
            onReservationFlowSelect?(controller)
        } else {
            onProfileFlowSelect?(controller)
        }
    }
}
