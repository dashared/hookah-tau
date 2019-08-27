//
//  ViewController.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    var handlerAuthentication: (() -> Void)?

    let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)
        return button
    }()

    @objc func tapHandlerNextButton() {
        handlerAuthentication?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Authentication"
        self.view.backgroundColor = .red
        self.view.addSubview(nextButton)

        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }


}

