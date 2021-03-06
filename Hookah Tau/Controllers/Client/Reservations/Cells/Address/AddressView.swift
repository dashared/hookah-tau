//
//  AddressView.swift
//  Hookah Tau
//
//  Created by cstore on 25/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AddressView: UIView {
    
    // MARK: - Properties

    @IBOutlet weak var addressLabel: UILabel?
    
    @IBOutlet weak var openHoursLabel: UILabel?
    
    @IBOutlet weak var tableCountLabel: UILabel?
    
    @IBOutlet weak var mapImageView: UIImageView?
    
    func bind(withModel model: TotalStorage.EstablishmentData) {
        addressLabel?.text = model.address
        tableCountLabel?.text = "\(model.maxTableNumber) столов"
        mapImageView?.image = model.image
    }
    
}
