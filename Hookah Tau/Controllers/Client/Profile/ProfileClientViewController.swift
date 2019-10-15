//
//  ProfileViewController.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ProfileClientViewController: UIViewController {

    // MARK: - Properties
    
    var profileContentView: ProfileView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        profileContentView = ProfileView.loadFromNib()
        profileContentView?.bind(withModel: (false, "Стасик", "+7 999 831 41 59"))
        view.addSubviewThatFills(profileContentView)
    }
    

}
