//
//  InputViewController.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 26/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

final class CodeSmsViewController: AuthorizationViewController {
    
    // MARK: - Properties

    weak var coordinator: CodeCoordinator?
    
    weak var codeView: CodeView?
    
    var userName: String?
    
    var authService: AuthorizationService?

    let nextButton: Button = {
        let button = Button(frame: CGRect.zero)
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
        
        authService = AuthorizationService(apiClient: APIClient.shared)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        codeView?.fst?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        codeView?.fst?.resignFirstResponder()
    }
    
    // MARK: - Setup
    
    private func setUpButtons() {
        let style = BlackButtonStyle()
        style.apply(to: returnButton, withTitle: "НАЗАД")
        style.apply(to: nextButton, withTitle: "ДАЛЕЕ")
        
        addStackViewWithButtons(leftBtn: returnButton, rightBtn: nextButton)
        
        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(tapHandlerReturnButton), for: .touchUpInside)
    }
    
    private func setUpContentView() {
        codeView = CodeView.loadFromNib()
        setUpContentView(withModel:
            RegistationViewModel(title: "Вам должно придти сообщение.\nКакой в нем код?",
                                 view: codeView))
    }
    
    // MARK: - Handlers
    
    @objc
    func tapHandlerNextButton() {
        guard let phonecode = codeView?.getFullCode() else {
            displayAlert(forError: GeneralError.noData)
            return
        }
        
        let handleCompletion: (Result<User, GeneralError>) -> Void = { [weak self] result in
            self?.nextButton.loading = false
            switch result {
            case .failure(let err):
                self?.displayAlert(forError: err)
            case .success:
                self?.coordinator?.goToNextStep()
            }
        }
        
        nextButton.loading = true
        
        if let name = userName {
            authService?.register(name: name,
                                  code: phonecode,
                                  phoneNumber: "888888888",
                                  completion: handleCompletion)
            return
        }
        
        authService?.phonecode(phoneNumber: "888888888",
                               code: phonecode,
                               completion: handleCompletion)
    }
    
    @objc
    func tapHandlerReturnButton() {
        coordinator?.goBack()
    }
    
}
