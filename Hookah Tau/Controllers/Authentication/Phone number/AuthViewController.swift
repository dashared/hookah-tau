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

    var phoneView: UIView?

    let contentView: TitleTextView = {
        let view = TitleTextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 256))
        return view
    }()

    let nextButton: Button = {
        let button = Button(frame: CGRect(x: 0, y: 0, width: 155, height: 37))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc func tapHandlerNextButton() {
        coordinator?.goToNextStep()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        self.view.addSubview(nextButton)

        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)

        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        let style = BlackButtonStyle()
        style.apply(to: nextButton, withTitle: "ДАЛЕЕ")

        phoneView = PhoneView.loadFromNib()
        contentView.bind(model: RegistationViewModel(title: "Введите Ваш номер телефона", view: phoneView))
        self.view.addSubview(contentView)

    }


}

