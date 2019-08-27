//
//  BaseCoordinator.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


/// Main protocol for application flow
protocol Coordinator: class {

    var navigationController: UINavigationController? { get set }
    var didEndFlow: (() -> Void)? { get set }

    func start()

    init(navigationController: UINavigationController?)
}

/// Main base class for inheritance
class BaseCoordinator: Coordinator {
    private(set) var window: UIWindow?
    var navigationController: UINavigationController?

    var didEndFlow: (() -> Void)?

    func start() { } // should be overriden

    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    convenience init(window: UIWindow?) {
        self.init(navigationController: window?.rootViewController as? UINavigationController)
        self.window = window
    }
}
