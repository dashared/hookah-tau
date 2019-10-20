//
//  NoReservationsView.swift
//  Hookah Tau
//
//  Created by cstore on 20/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class NoReservationsView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var noReservLabel: UILabel? {
        didSet {
            noReservLabel?.text =
            "Вы пока не забронировали ни один столик :("
        }
    }
    
    @IBOutlet weak var makeReservationButton: Button? {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: makeReservationButton, withTitle: "ЗАБРОНИРОВАТЬ")
        }
    }
}
