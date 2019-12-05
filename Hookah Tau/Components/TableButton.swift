//
//  TableButton.swift
//  Hookah Tau
//
//  Created by cstore on 18/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class TableButton: UIButton {
    
    var style: TableButtonStyle?
    
    var isChosen: Bool = false {
        didSet {
            if isChosen {
                style?.setSelected(button: self)
            } else {
                style?.setUnselected(button: self)
            }
        }
    }
    
    var isBooked: Bool = false {
        didSet {
            if !isBooked {
                style?.setAvaliable(button: self)
            } else {
                style?.setBooked(button: self)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func select() {
        isChosen = true
    }
    
    func active() {
        isBooked = false
    }
    
    func inactive() {
        isBooked = true
    }
    
    func unselect() {
        isChosen = false
    }
}
