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
    
    var model: User? {
        didSet {
            guard let model = model else { return }
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
        profileContentView?.logOutButton?.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        model = DataStorage.standard.getUserModel()
        
        view.addSubviewThatFills(profileContentView)
        
        setUpTextFields()
    }
    
    @objc func presentChangeViewPhone() {
        guard let model = model else { return }
        let changeModel = ChangeModel(userModel: model, editingOption: .phone)
        coordinator?.presentEditMode(withModel: changeModel)
    }
    
    @objc func presentChangeViewInvite() {
        guard let model = model else { return }
        let changeModel = ChangeModel(userModel: model, editingOption: .invite)
        coordinator?.presentEditMode(withModel: changeModel)
    }
    
    @objc func presentChangeViewName() {
        guard let model = model else { return }
        let changeModel = ChangeModel(userModel: model, editingOption: .name)
        coordinator?.presentEditMode(withModel: changeModel)
    }
    
    @objc func logout() {
        coordinator?.logout()
    }
}

// MARK: - UserUpdate ext

extension ProfileClientViewController: UserUpdate {
    func updateUser(withModel model: User) {
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
