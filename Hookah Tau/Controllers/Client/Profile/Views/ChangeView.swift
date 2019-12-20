//
//  ChangeView.swift
//  Hookah Tau
//
//  Created by cstore on 20/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class ChangeView: UIView {
    
    var type: EditingOption = .invite
    
    @IBOutlet weak var titleLabel: UILabel?
    
    @IBOutlet weak var textField: UITextField?
    
    func bind(withModel model: ChangeModel) {
        self.textField?.delegate = self
        self.type = model.editingOption
        
        switch model.editingOption {
        case .invite:
            titleLabel?.text = "Добавить администратора"
            textField?.placeholder = "+ 7 (888) 888-88-88"
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

extension ChangeView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(newString)
        return false
    }
    
    private func formattedNumber(_ number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        let phoneMask = "+X (XXX) XXX XX XX"
        var index = cleanPhoneNumber.startIndex
        for ch in phoneMask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
