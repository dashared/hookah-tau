//
//  ChangeView.swift
//  Hookah Tau
//
//  Created by cstore on 20/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class ChangeView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel?
    
    @IBOutlet weak var textField: UITextField?
    
    func bind(withModel model: ChangeModel) {
        switch model.editingOption {
        case .invite:
            titleLabel?.text = "Добавить администратора"
            textField?.placeholder = "+ 7 888 888 88 88"
            textField?.keyboardType = .numberPad
        case .name:
            titleLabel?.text = "Имя"
            textField?.text = model.userModel.name
            textField?.keyboardType = .alphabet
        case .phone:
            titleLabel?.text = "Номер телефона"
            textField?.text = model.userModel.phoneNumber
            textField?.keyboardType = .numberPad
        }
    }
}
