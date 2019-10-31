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

    var nameView: NameTextView?

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

        setUpContentView()
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        nameView?.nameTextField?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nameView?.nameTextField?.resignFirstResponder()
    }
    
    // MARK: - Setup
    
    func setUpButtons() {
        let style = BlackButtonStyle()
        style.apply(to: nextButton, withTitle: "ДАЛЕЕ")
        style.apply(to: returnButton, withTitle: "НАЗАД")
        addStackViewWithButtons(leftBtn: returnButton, rightBtn: nextButton)
        
        returnButton.addTarget(self, action: #selector(tapHandlerReturnButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)
    }
    
    func setUpContentView() {
        nameView = NameTextView.loadFromNib()
        setUpContentView(withModel: RegistationViewModel(title: "Как Вас зовут?",
                                                         view: nameView))
    }
    
    // MARK: - Handlers

    @objc func tapHandlerNextButton() {
        guard let name = nameView?.nameTextField?.text else {
            displayAlert(forError: GeneralError.noData)
            return
        }
        
        DataStorage.standard.name = name
        coordinator?.goToNextStep()
    }
    
    @objc func tapHandlerReturnButton() {
        coordinator?.goBack()
    }
}

