//
//  AddressTableViewCell.swift
//  Hookah Tau
//
//  Created by cstore on 27/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

let addressCellIdentifier = "AddressCell"

class AddressCell: UITableViewCell {
    
    // MARK: - Properties
    
    var addressView: AddressView?

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addressView = AddressView.loadFromNib()
        contentView.addSubviewThatFills(addressView)
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}
