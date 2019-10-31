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
    
    var authService: AuthorizationService?
    
    let nextButton: Button = {
        let button = Button()
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
        setUpContentView()
        
        authService = AuthorizationService(apiClient: APIClient.shared)
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
        style.apply(to: nextButton, withTitle: "ДАЛЕЕ")
        
        addStackViewWithButtons(rightBtn: nextButton)
        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)
    }
    
    func setUpContentView() {
        phoneView = PhoneView.loadFromNib()
        setUpContentView(withModel: RegistationViewModel(title: "Введите Ваш номер телефона",
                                                         view: phoneView))
    }
    
    // MARK: - Handlers
 
    @objc
    func tapHandlerNextButton() {
        nextButton.loading = true
        authService?.authenticate(withPhone: "888888888", completion: { [weak self] (result) in
            self?.nextButton.loading = false
            
            switch result {
            case .failure(let err):
                self?.displayAlert(forError: err)
            case .success(let isUserRegistered):
                self?.coordinator?.goToNextStep(isUserRegistered: isUserRegistered)
            }
        })
    }
}
