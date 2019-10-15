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
        
        phone?.keyboardType = .numberPad
        phone?.attributedPlaceholder = NSAttributedString(string:"+ 7 901 733 01 79", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    // TODO: - change in future
    func bind(withModel model: String) {
        phone?.text = model
    }

}
