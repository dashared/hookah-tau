//
//  PhoneTextField.swift
//  Hookah Tau
//
//  Created by cstore on 13/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import UIKit

class PhoneTextField: UITextField, UITextFieldDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.keyboardType = .numberPad
    }
    
    func bind(withModel model: String) {
        self.text = model.formattedNumber()
    }
    
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
    
    /// +o  (oxx) xxx xx xx
    ///
    /// need tor return only `x`, length is 9. And it has to have prefix +7 (9...) or +8 (9..)
    func getFormattedNumber() -> String? {
        guard let number = self.text else { return nil }
        
        let cleanPhoneNumber = String(number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        let hasPrefix = cleanPhoneNumber.hasPrefix("79") || cleanPhoneNumber.hasPrefix("89")
        
        let result = String(cleanPhoneNumber.dropFirst(2))
        if result.count == 9 && hasPrefix {
            return result
        }
        
        return nil
    }
}
