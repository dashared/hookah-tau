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

    var childCoordinators: [Coordinator] { get set }

    func start()

    init(navigationController: UINavigationController?)
}

/// Main base class for inheritance
class BaseCoordinator: Coordinator {

    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController?
    
    var didEndFlow: (() -> Void)?
    
    weak var parentCoordinator: BaseCoordinator?

    func start() { } // should be overriden

    // add only unique object
    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {  return }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }

        // Clear child-coordinators recursively
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter({ $0 !== coordinator })
                .forEach({ coordinator.removeDependency($0) })
        }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

}
