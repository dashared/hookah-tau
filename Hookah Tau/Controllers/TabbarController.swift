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
    var onChannelsFlowSelect: ((UINavigationController) -> ())? { get set }
    var onProfileFlowSelect: ((UINavigationController) -> ())? { get set }
    var onMessagesFlowSelect: ((UINavigationController) -> ())? { get set }
    var onViewDidLoad: ((UINavigationController) -> ())? { get set }
}

//final class TabbarController: UITabBarController, UITabBarControllerDelegate, TabbarView {
//
//}
