//
//  AdminNoReservationsView.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminNoReservationsView: UIView {

    // MARK: - IBAOutlets
    
    @IBOutlet weak var bookButton: Button? {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: bookButton)
        }
    }
    
}
