//
//  Button.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class Button: UIButton {
    public var loading = false {
        willSet {
            willUpdateLoadingState(newValue: newValue)
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.8
        }
    }

    private func willUpdateLoadingState(newValue loading: Bool) {
        isEnabled = loading

        if loading {
            //
        } else {
            //
        }
    }

    private func createAnimation() {
        
    }
}
