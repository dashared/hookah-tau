//
//  ClientTableViewCell.swift
//  Hookah Tau
//
//  Created by cstore on 09/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

let clientTableViewCellId = "ClientTableViewCell"

class ClientTableViewCell: UITableViewCell {
    
    // MARK: - IBAOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var numberOfReservationsLabel: UILabel!
    
    
    @IBOutlet weak var blockListLabel: UILabel!
    
    @IBOutlet weak var isAdminLabel: UILabel!
    
    
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Bind
    
    func bind(withModel model: Client) {
        blockListLabel.isHidden = !model.isBlocked
        isAdminLabel.isHidden = !model.isAdmin
        nameLabel.text = model.name ?? "❔"
        phoneNumberLabel.text = model.phoneNumber.formattedNumber()
        numberOfReservationsLabel.text = model.reservationCount > 99 ? "99+" : "\(model.reservationCount)"
    }

}
