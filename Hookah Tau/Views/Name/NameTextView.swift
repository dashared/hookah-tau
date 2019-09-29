//
//  NameTextView.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 29/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class NameTextView: UIView {

    @IBOutlet weak var nameTextField: UITextField?

    // TODO: - change in future
    func bind(withModel model: String) {
        nameTextField?.text = model
    }

}
