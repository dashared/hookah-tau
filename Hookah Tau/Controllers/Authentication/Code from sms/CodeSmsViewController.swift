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
    
    weak var codeView: UIView?

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
        setUpContentView()
    }
    
    // MARK: - Setup
    
    private func setUpButtons() {
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
    
    private func setUpContentView() {
        codeView = CodeView.loadFromNib()
        setUpContentView(withModel:
            RegistationViewModel(title: "Вам должно придти сообщение.\nКакой в нем код?",
                                 view: codeView))
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
