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

    @IBOutlet weak var firstRange: UITextField?

    @IBOutlet weak var secondRange: UITextField?

    @IBOutlet weak var thirdRange: UITextField?

    @IBOutlet weak var forthRange: UITextField?
    
    private var allRanges: [UITextField] = []
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        allRanges = [firstRange,
                     secondRange,
                     thirdRange,
                     forthRange].compactMap{ $0 }
        
        _ = allRanges.map { $0.keyboardType = .numberPad }
    }

}
