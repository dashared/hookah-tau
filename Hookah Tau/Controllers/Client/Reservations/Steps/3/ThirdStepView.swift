//
//  ThirdStepView.swift
//  Hookah Tau
//
//  Created by cstore on 23/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

struct ThirdStepViewModel {
    var timeIntervalView: UIView
}

class ThirdStepView: UIView {
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var closeButton: Button! {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: closeButton, withTitle: "ЗАКРЫТЬ")
        }
    }
    
    
    @IBOutlet weak var timeInterval: UIView!
    

    func bind(withModel model: ThirdStepViewModel) {
        
    }
}
