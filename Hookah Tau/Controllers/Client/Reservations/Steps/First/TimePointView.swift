//
//  TimePointView.swift
//  Hookah Tau
//
//  Created by cstore on 15/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class TimePointView: UIView {

    // MARK: - Properties
    
    @IBOutlet weak var timePoint: UIView! {
        didSet {
            timePoint.layer.cornerRadius = 2
        }
    }
    
    @IBOutlet weak var heightTimePoint: NSLayoutConstraint!
    
    @IBOutlet weak var timePointContainer: UIView! {
        didSet {
            timePointContainer.layer.masksToBounds = false
            timePointContainer.layer.shadowOffset = CGSize(width: 0, height: -3)
            timePointContainer.layer.shadowRadius = 1
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Set up
    
    func setUp(withTimePoint time: Int) {
        if time % 6 != 0 {
            timeLabel.isHidden = true
            heightTimePoint.constant = 24
        } else {
            timeLabel.isHidden = false
            timeLabel.text = TimePointView.getTextTimeFromTimePoint(time)
        }
    }
    
    // MARK: - Static
    
    static func getTextTimeFromTimePoint(_ time: Int) -> String {
        return "\((Int(time / 6) + 12) % 24):00"
    }
}
