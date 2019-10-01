//
//  ViewController.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {

    weak var coordinator: NameCoordinator?

    var phoneView: UIView?

    let contentView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 60, width: UIScreen.main.bounds.width-20, height: 259))
        return view
    }()

    var titleTextView: TitleTextView?

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

        titleTextView = TitleTextView.loadFromNib()
        phoneView = PhoneView.loadFromNib()
        titleTextView?.bind(model: RegistationViewModel(title: "Введите Ваш номер телефона", view: phoneView))
        self.view.addSubview(contentView)

        contentView.addSubviewThatFills(titleTextView)
    }


}

