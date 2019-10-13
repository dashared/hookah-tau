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
    var onReservationFlowSelect: ((UINavigationController) -> ())? { get set }
    var onProfileFlowSelect: ((UINavigationController) -> ())? { get set }
    var onViewDidLoad: ((UINavigationController) -> ())? { get set }
}

final class ClientTabbarController: UITabBarController, UITabBarControllerDelegate, TabbarView {
    
    // MARK: - Properties
    
    var onReservationFlowSelect: ((UINavigationController) -> ())?
    var onProfileFlowSelect: ((UINavigationController) -> ())?
    var onViewDidLoad: ((UINavigationController) -> ())?
    
    
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
