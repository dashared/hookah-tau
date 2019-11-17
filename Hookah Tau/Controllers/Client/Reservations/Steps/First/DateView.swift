//
//  DateView.swift
//  Hookah Tau
//
//  Created by cstore on 15/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class DateView: UIView {

    @IBOutlet weak var dateLabel: UILabel!
    
    func setUp(with date: IntervalDate) {
        dateLabel.text = "\(date.day)"
    }
}
