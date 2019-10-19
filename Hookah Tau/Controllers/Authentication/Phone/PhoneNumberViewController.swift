//
//  NameViewController.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

final class PhoneNumberViewController: AuthorizationViewController {

    // MARK: - Properties

    weak var coordinator: PhoneCoordinator?

    var phoneView: PhoneView?
    
    let nextButton: Button = {
        let button = Button()
        return button
    }()
    
    let returnButton: Button = {
        let button = Button()
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
        setUpContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        phoneView?.phone?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        phoneView?.phone?.resignFirstResponder()
    }
    
    // MARK: - Setup
    
    func setUpButtons() {
        let style = BlackButtonStyle()
        style.apply(to: returnButton, withTitle: "НАЗАД")
        style.apply(to: nextButton, withTitle: "ДАЛЕЕ")
        
        addStackViewWithButtons(leftBtn: returnButton, rightBtn: nextButton)
        
        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(tapHandlerReturnButton), for: .touchUpInside)
    }
    
    func setUpContentView() {
        phoneView = PhoneView.loadFromNib()
        setUpContentView(withModel: RegistationViewModel(title: "Введите Ваш номер телефона",
                                                         view: phoneView))
    }
    
    // MARK: - Handlers
 
    @objc
    func tapHandlerNextButton() {
        coordinator?.goToNextStep()
    }
    
    @objc
    func tapHandlerReturnButton() {
        coordinator?.goBack()
    }
}
