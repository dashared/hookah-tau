//
//  ProfileViewController.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ProfileClientViewController: UIViewController {

    // MARK: - Properties
    
    weak var coordinator: ProfileCoordinator?
    
    var model: UserModel = UserModel(name: "Стасик", phone: "+ 8 901 733 01 79", isAdmin: false) {
        didSet {
            profileContentView?.bind(withModel: model)
        }
    }
    
    var profileContentView: ProfileView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
    
        profileContentView = ProfileView.loadFromNib()
        profileContentView?.bind(withModel: model)
        
        view.addSubviewThatFills(profileContentView)
        
        setUpTextFields()
    }
    
    @objc func presentChangeViewPhone() {
        let changeModel = ChangeModel(userModel: model, editingOption: .phone)
        coordinator?.presentEditMode(withModel: changeModel)
    }
    
    @objc func presentChangeViewInvite() {
        let changeModel = ChangeModel(userModel: model, editingOption: .invite)
        coordinator?.presentEditMode(withModel: changeModel)
    }
    
    @objc func presentChangeViewName() {
        let changeModel = ChangeModel(userModel: model, editingOption: .name)
        coordinator?.presentEditMode(withModel: changeModel)
    }
}

// MARK: - UserUpdate ext

extension ProfileClientViewController: UserUpdate {
    func updateUser(withModel model: UserModel) {
        self.model = model
    }
}

// MARK: - UITextFieldDelegate ext

extension ProfileClientViewController: UITextFieldDelegate {
    func setUpTextFields() {
        profileContentView?.phoneView?.phone?.delegate = self
        profileContentView?.inviteAdminPhoneView?.phone?.delegate = self
        profileContentView?.nameView?.nameTextField?.delegate = self
        
        profileContentView?.phoneView?.phone?
            .addTarget(self, action: #selector(presentChangeViewPhone), for: .allTouchEvents)
        profileContentView?.inviteAdminPhoneView?.phone?
            .addTarget(self, action: #selector(presentChangeViewInvite), for: .allTouchEvents)
        profileContentView?.nameView?.nameTextField?
            .addTarget(self, action: #selector(presentChangeViewName), for: .allTouchEvents)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
