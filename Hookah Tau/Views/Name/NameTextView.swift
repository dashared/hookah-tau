//
//  NameTextView.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 29/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class NameTextView: UIView {
    
    // MARK: - Properties

    @IBOutlet weak var nameTextField: UITextField?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField?.keyboardType = .alphabet
        nameTextField?.attributedPlaceholder = NSAttributedString(string:"Стасик", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

    // TODO: - change in future
    func bind(withModel model: String) {
        nameTextField?.text = model
    }

}
