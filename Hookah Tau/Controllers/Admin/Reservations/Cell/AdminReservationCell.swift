//
//  AdminReservationCell.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminReservationCell: UITableViewCell {
    
    // MARK:- IBAOutlets
    
    @IBOutlet weak var tableImage: UIImageView?
    
    @IBOutlet weak var guestNumber: UILabel?
    
    @IBOutlet weak var dateLabel: UILabel?
    
    @IBOutlet weak var timeLabel: UILabel?
    
    @IBOutlet weak var personLabel: UILabel?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - bind
    
    func bind(withModel model: ReservationWithUser) {
        let (date, time) = Date.format(model.startTime, model.endTime)
        
        dateLabel?.text = date
        timeLabel?.text = time
        
        guestNumber?.text = setPeople(number: model.numberOfGuests)
        personLabel?.text = model.owner.name ?? "❔❔❔"
        tableImage?.image = TotalStorage.standard.getTable(establishment: model.establishment, table: model.reservedTable)?.image
    }
    
    func setPeople(number: Int) -> String {
        switch number {
        case 2...4:
            return "\(number) человека"
        default:
            return "\(number) человек"
        }
    }
}
