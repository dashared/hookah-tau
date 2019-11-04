//
//  CodeView.swift
//  Hookah Tau
//
//  Created by cstore on 07/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class CodeView: UIView {
    
    // MARK: - Properties

    @IBOutlet weak var firstTextField: UITextField?
    
    @IBOutlet weak var lastTextField: UITextField?
    
    @IBOutlet var codeTextFields: [UITextField]?

    var onComplete: ((String?) -> Void)?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _ = codeTextFields?.map {
            $0.delegate = self
            $0.keyboardType = .asciiCapableNumberPad
        }
    }
    
    func getFullCode() -> String? {
        guard let codeArray = codeTextFields else { return nil }
        let code = codeArray.map { $0.text ?? "" }.reduce("", +)
        
        return code
    }
}

// MARK: - UITextFieldDelegate

extension CodeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")

        if (isBackSpace == -92) {
            getBackwards(textField)
            return false
        } else {
            let newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string).last
            if let newFirstString = newString {
                textFieldShouldReturnSingle(textField, newString: String(newFirstString))
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturnSingle(_ textField: UITextField, newString: String)
    {
        textField.text = newString
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
            onComplete?(getFullCode())
        }
    }
    
    func getBackwards(_ textField: UITextField) {
        textField.text = ""
        if let nextTextField = textField.superview?.viewWithTag(textField.tag - 1) {
            nextTextField.becomeFirstResponder()
        }
    }
}
