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

    var phoneView: UIView?

    var titleTextView: TitleTextView?

    let nextButton: Button = {
        let button = Button(frame: CGRect.zero)
        return button
    }()
    
    let returnButton: Button = {
        let button = Button(frame: CGRect.zero)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        setUpButtons()
        setUpMainView()
    }
    
    // MARK: - Setup
    
    func setUpButtons() {
        let style = BlackButtonStyle()
        style.apply(to: returnButton, withTitle: "НАЗАД")
        style.apply(to: nextButton, withTitle: "ДАЛЕЕ")
        
        NSLayoutConstraint.activate([
            returnButton.widthAnchor.constraint(equalToConstant: 155),
            nextButton.widthAnchor.constraint(equalToConstant: 155)
        ])
        
        addStackViewWithButtons(leftBtn: returnButton, rightBtn: nextButton)
        
        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(tapHandlerReturnButton), for: .touchUpInside)
    }
    
    func setUpMainView() {
        titleTextView = TitleTextView.loadFromNib()
        phoneView = PhoneView.loadFromNib()
        titleTextView?.bind(model: RegistationViewModel(title: "Введите Ваш номер телефона", view: phoneView))
        
        contentView.addSubviewThatFills(titleTextView)
        addStackViewWithButtons(leftBtn: returnButton, rightBtn: nextButton)
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
