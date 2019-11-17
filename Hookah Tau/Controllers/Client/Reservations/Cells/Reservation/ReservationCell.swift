//
//  ReservationCell.swift
//  Hookah Tau
//
//  Created by cstore on 20/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationCell: UITableViewCell {
    
    // MARK: - Properties

    var reservationCellView: ReservationView?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        reservationCellView = ReservationView.loadFromNib()
        contentView.addSubviewThatFills(reservationCellView)
        
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data

    func bind(withModel model: Reservation) {
        self.reservationCellView?.maxPeopleLabel?.text = "\(model.numberOfGuests)"
    }

}
