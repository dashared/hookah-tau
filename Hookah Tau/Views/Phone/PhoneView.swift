//
//  PhoneView.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 29/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class PhoneView: UIView {

    // MARK:- Properties

    @IBOutlet weak var phone: UITextField?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        phone?.delegate = self
        phone?.keyboardType = .numberPad
        phone?.attributedPlaceholder = NSAttributedString(string:"+ 7 (901) 733 01 79", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    // TODO: - change in future
    func bind(withModel model: String) {
        phone?.text = model
    }
}

// MARK: - UITextFieldDelegate

extension PhoneView: UITextFieldDelegate {
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
        guard let number = phone?.text else { return nil }
        
        let cleanPhoneNumber = String(number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        let hasPrefix = cleanPhoneNumber.hasPrefix("79") || cleanPhoneNumber.hasPrefix("89")
        
        let result = String(cleanPhoneNumber.dropFirst(2))
        if result.count == 9 && hasPrefix {
            return result
        }
        
        return nil
    }
}
