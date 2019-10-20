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

    var reservationCellView: ReservationCellView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        reservationCellView = ReservationCellView.loadFromNib()
        self.contentView.addSubviewThatFills(reservationCellView)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(withModel model: Int) {
        
    }

}
