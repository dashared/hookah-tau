//
//  ViewController.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/08/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class NameViewController: AuthorizationViewController {

    // MARK: - Properties

    weak var coordinator: NameCoordinator?

    var nameView: UIView?

    let nextButton: Button = {
        let button = Button(frame: CGRect.zero)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
        setUpContentView()
    }
    
    // MARK: - Setup
    
    func setUpButtons() {
        let style = BlackButtonStyle()
        style.apply(to: nextButton, withTitle: "ДАЛЕЕ")

        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)
        nextButton.widthAnchor.constraint(equalToConstant: 155).isActive = true
        
        addStackViewWithButtons(rightBtn: nextButton)
    }
    
    func setUpContentView() {
        nameView = NameTextView.loadFromNib()
        setUpContentView(withModel: RegistationViewModel(title: "Как Вас зовут?",
                                                         view: nameView))
    }
    
    // MARK: - Handlers

    @objc func tapHandlerNextButton() {
        coordinator?.goToNextStep()
        //nextButton.loading = true
    }
}

