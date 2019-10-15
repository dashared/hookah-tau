//
//  ProfileView.swift
//  Hookah Tau
//
//  Created by cstore on 14/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel? {
        didSet {
            nameLabel?.text = "Имя:"
        }
    }
    
    @IBOutlet weak var phoneLabel: UILabel? {
        didSet {
            phoneLabel?.text = "Телефон: "
        }
    }
    
    @IBOutlet weak var inviteLabel: UILabel? {
        didSet {
            inviteLabel?.text = "Добавить администратора:"
        }
    }
    
    @IBOutlet weak var nameContainerView: UIView?
    
    @IBOutlet weak var phoneContainerView: UIView?
    
    @IBOutlet weak var invitationContainerView: UIView!
    
    var phoneView: PhoneView?

    var nameView: NameTextView?
    
    var inviteAdminPhoneView: PhoneView?
    
    @IBOutlet weak var inviteStackView: UIStackView?
    
    @IBOutlet weak var logOutButton: UIButton?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        phoneView = PhoneView.loadFromNib()
        inviteAdminPhoneView = PhoneView.loadFromNib()
        nameView = NameTextView.loadFromNib()
        
        nameContainerView?.addSubviewThatFills(nameView)
        phoneContainerView?.addSubviewThatFills(phoneView)
        invitationContainerView?.addSubviewThatFills(inviteAdminPhoneView)
    }
    
    // TODO: - change in future
    func bind(withModel model: (isAdmin: Bool, name: String, phone: String)) {
        
        nameView?.bind(withModel: model.name)
        phoneView?.bind(withModel: model.phone)
        
        if !model.isAdmin {
            inviteStackView?.isHidden = true
        }
    }
    
}
