//
//  AdminSecondStepReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 13/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminSecondStepReservationViewController: BaseViewController {
    
    // MARK: - IBAOutlets
    
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phoneTextField: PhoneTextField!
    
    @IBOutlet weak var phoneContentView: UIView!
    
    // MARK: - Properties
    
    var mapScrollView: MapImageScroll?
    
    weak var coordinator: AdminSecondStepReservationViewCoordinator?
    
    let continueButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ДАЛЕЕ")
        return button
    }()
    
    let cancelButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ОТМЕНИТЬ")
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        setupButtons()
        setUpKeyboard()
        
        phoneTextField.becomeFirstResponder()
    }
    
    // MARK: - Set up
    
    func setupMap() {
        mapScrollView?.scrollToTable(table: 8)
        mapContainerView.addSubviewThatFills(mapScrollView)
    }
    
    func setupButtons() {
        addStackViewWithButtons(leftBtn: cancelButton,
                                rightBtn: continueButton,
                                constant: -phoneContentView.frame.height - 20)
           
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueBooking), for: .touchUpInside)
    }
    
    // MARK: - Keyboad
    
    @objc
    override func handleKeyboardNotifications(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            heightConstraint?.constant = notification.name == UIResponder.keyboardWillShowNotification ? keyBoardFrame.height + view.safeAreaInsets.bottom + 120.5 : 120.5
            bottomConstraint?.constant = notification.name == UIResponder.keyboardWillShowNotification ? -keyBoardFrame.height + view.safeAreaInsets.bottom - 140.5 : -140.5
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Button handlers
    
    @objc func cancel() {
        coordinator?.didEndFlow?()
    }
    
    @objc func continueBooking() {
        
    }
       

}
