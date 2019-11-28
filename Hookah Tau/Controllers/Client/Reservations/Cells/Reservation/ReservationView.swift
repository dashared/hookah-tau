//
//  ReservationCellView.swift
//  Hookah Tau
//
//  Created by cstore on 20/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var adressLabel: UILabel?
    
    @IBOutlet weak var dateLabel: UILabel?
    
    @IBOutlet weak var timeLabel: UILabel?
    
    @IBOutlet weak var maxPeopleLabel: UILabel?
    
    @IBOutlet weak var tableImageView: UIImageView?

    func bind(withModel model: Reservation) {
        guard let table = TotalStorage.standard.getTable(establishment: model.establishment, table: model.reservedTable),
            let establishment = TotalStorage.standard.getEstablishment(model.establishment)
        else { return }
        
        tableImageView?.image = table.image
        adressLabel?.text = establishment.address
        maxPeopleLabel?.text = "\(model.numberOfGuests) человека"
    }
    
}
