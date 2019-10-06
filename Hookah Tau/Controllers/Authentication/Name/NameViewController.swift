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

    var titleTextView: TitleTextView?

    let nextButton: Button = {
        let button = Button(frame: CGRect(x: 0, y: 0, width: 155, height: 37))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white

        self.view.addSubview(nextButton)


        let style = BlackButtonStyle()
        style.apply(to: nextButton, withTitle: "ДАЛЕЕ")

        nextButton.addTarget(self, action: #selector(tapHandlerNextButton), for: .touchUpInside)
        //nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 155).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 37).isActive = true
        
        addStackViewWithButtons(rightBtn: nextButton)
        setUpContentView()
    }
    
    // MARK: - Setup
    
    func setUpContentView() {
        titleTextView = TitleTextView.loadFromNib()
        nameView = NameTextView.loadFromNib()
        titleTextView?.bind(model: RegistationViewModel(title: "Как Вас зовут?", view: nameView))

        contentView.addSubviewThatFills(titleTextView)
    }
    
    // MARK: - Handlers

    @objc func tapHandlerNextButton() {
        //coordinator?.goToNextStep()
        nextButton.loading = true
    }
}

