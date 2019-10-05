//
//  NameViewController.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class PhoneNumberViewController: AuthorizationViewController {

    // MARK: - Properties

    weak var coordinator: PhoneCoordinator?

    var phoneView: UIView?

    var titleTextView: TitleTextView?

    let contentView: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()

    let nextButton: Button = {
        let button = Button(frame: CGRect(x: 0, y: 0, width: 155, height: 37))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(nextButton)
        constaintContentViewToSuperview(view: contentView, superview: view)

        titleTextView = TitleTextView.loadFromNib()
        phoneView = PhoneView.loadFromNib()
        titleTextView?.bind(model: RegistationViewModel(title: "Введите Ваш номер телефона", view: phoneView))

        contentView.addSubviewThatFills(titleTextView)

        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    @objc
    func tapHandlerNextButton() {
        coordinator?.goToNextStep()
    }
}
