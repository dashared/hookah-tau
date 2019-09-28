//
//  ViewController.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    weak var coordinator: AuthCoordinator?

    let nextButton: Button = {
        let button = Button(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc func tapHandlerNextButton() {
        coordinator?.goToNextStep()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .red
        self.view.addSubview(nextButton)

        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)

        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        nextButton.setTitle("Далее", for: .normal)
        let style = BlackButtonStyle()
        style.apply(to: nextButton)
    }


}

