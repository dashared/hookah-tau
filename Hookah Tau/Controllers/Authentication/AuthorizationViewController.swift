//
//  Extension+UIVC.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 05/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit



class AuthorizationViewController: UIViewController {
    
    // MARK: - Properties
    
    var keyboardBarStack: UIView?
    
    var bottomConstraint: NSLayoutConstraint?
    
    let contentView: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constaintContentViewToSuperview(authView: contentView)
        
        setUpKeyboard()
    }

    // MARK: - Methods

    private func constaintContentViewToSuperview(authView: UIView) {
        view.addSubview(authView)

        authView.translatesAutoresizingMaskIntoConstraints = false

        authView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        authView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        authView.widthAnchor.constraint(equalToConstant: 374).isActive = true
        authView.heightAnchor.constraint(equalToConstant: 219).isActive = true
    }
    
    // MARK: - Buttons
    
    func addStackViewWithButtons(leftBtn: Button? = nil, rightBtn: Button? = nil) {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .red
        view.addSubview(stackView)
        
        bottomConstraint = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        guard let bottomContraint = bottomConstraint else { return }
        view.addConstraint(bottomContraint)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        switch (leftBtn, rightBtn) {
        case (.some(let leftButton), .none):
            setUpLeftButton(leftButton, stackView)
        case (.none, .some(let rigthButton)):
            setUpRightButton(rigthButton, stackView)
        case (.some(let leftButton), .some(let rightButton)):
            setUpTwoButtons(leftButton, rightButton, stackView)
        case (.none, .none):
            return;
        }
    }
    
    private func setUpTwoButtons(_ leftBtn: UIButton, _ rightBtn: UIButton, _ stackView: UIStackView) {
        stackView.addArrangedSubview(leftBtn)
        stackView.addArrangedSubview(rightBtn)
        
        stackView.spacing = 10
    }
    
    private func setUpLeftButton(_ leftBtn: UIButton, _ stackView: UIStackView) {
        stackView.addArrangedSubview(leftBtn)
        stackView.alignment = .trailing
    }
    
    private func setUpRightButton(_ rightBtn: UIButton, _ stackView: UIStackView) {
        stackView.addArrangedSubview(rightBtn)
        stackView.alignment = .leading
    }
    
    // MARK: - Keyboard
    
    private func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func handleKeyboardNotifications(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            bottomConstraint?.constant = notification.name == UIResponder.keyboardWillShowNotification ? -keyBoardFrame.height + view.safeAreaInsets.bottom : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
