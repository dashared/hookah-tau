//
//  AddressViewController.swift
//  Hookah Tau
//
//  Created by cstore on 25/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AddressViewController: BaseViewController {
    
    // MARK: - Properties
    
    weak var coordinator: AddressCoordinator?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationItem.title = "Заведения"
    }
}
