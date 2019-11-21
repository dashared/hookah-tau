//
//  Button.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class Button: UIButton {

    // MARK: - Properties

    var style: BlackButtonStyle?

    public var loading = false {
        willSet {
            willUpdateLoadingState(newValue: newValue)
        }
    }

    override var isEnabled: Bool {
        didSet {
            //alpha = isEnabled ? 1 : 0.8
        }
    }
    
    public var availiable = true {
        willSet {
            willUpdateBookingState(newValue: availiable)
        }
    }
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Private

    private func willUpdateLoadingState(newValue loading: Bool) {
        isEnabled = !loading

        if loading {
            style?.changeToLoadingStyle(button: self)
        } else {
            style?.backToNormalStyle(button: self)
        }
    }
    
    private func willUpdateBookingState(newValue avaliable: Bool) {
        isEnabled = !avaliable
        
        if availiable {
            style?.changeToAvailiableState(button: self)
        } else {
            style?.changeToBookedState(button: self)
        }
    }
}
