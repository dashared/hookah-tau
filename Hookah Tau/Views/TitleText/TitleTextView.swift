//
//  TitleText.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 29/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class TitleTextView: UIView {

    @IBOutlet weak var titleLabel: UILabel?

    @IBOutlet weak var view: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(model: RegistationViewModel) {
        titleLabel?.text = model.title
        view?.addSubviewThatFills(model.view)
    }

}
