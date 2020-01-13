//
//  BaseViewController.swift
//  Hookah Tau
//
//  Created by cstore on 19/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties

    var bottomConstraint: NSLayoutConstraint?
    
    // MARK: - Buttons
    
    func addStackViewWithButtons(leftBtn: Button? = nil,
                                 rightBtn: Button? = nil,
                                 constant: CGFloat = -20) {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .red
        view.addSubview(stackView)
        
        leftBtn?.translatesAutoresizingMaskIntoConstraints = false
        rightBtn?.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = NSLayoutConstraint(item: stackView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view.safeAreaLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: constant)
        
        guard let bottomContraint = bottomConstraint else { return }
        view.addConstraint(bottomContraint)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 40)
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
        
        view.layoutIfNeeded()
    }
    
    private func setUpTwoButtons(_ leftBtn: UIButton, _ rightBtn: UIButton, _ stackView: UIStackView) {
        NSLayoutConstraint.activate([
            leftBtn.widthAnchor.constraint(equalToConstant: 155),
            rightBtn.widthAnchor.constraint(equalToConstant: 155)
        ])
        
        stackView.addArrangedSubview(leftBtn)
        stackView.addArrangedSubview(rightBtn)
        
        stackView.distribution = .equalSpacing
    }
    
    private func setUpLeftButton(_ leftBtn: UIButton, _ stackView: UIStackView) {
        leftBtn.widthAnchor.constraint(equalToConstant: 155).isActive = true
        
        stackView.addArrangedSubview(leftBtn)
        stackView.alignment = .trailing
    }
    
    private func setUpRightButton(_ rightBtn: UIButton, _ stackView: UIStackView) {
        rightBtn.widthAnchor.constraint(equalToConstant: 155).isActive = true
        
        stackView.addArrangedSubview(rightBtn)

        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fillProportionally
    }
    
    // MARK: - Keyboard
    
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc
    func handleKeyboardNotifications(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            bottomConstraint?.constant = notification.name == UIResponder.keyboardWillShowNotification ? -keyBoardFrame.height + view.safeAreaInsets.bottom - 20 : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Alert
     
    func displayAlert(forError error: GeneralError = GeneralError.noData, with message: String? = nil) {
        var title: String? = message == nil ? error.localizedDescription : message
        switch error {
        case .serverError(let se):
            title = se.error
            fallthrough // да тоже произведение искусства
        default:
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
