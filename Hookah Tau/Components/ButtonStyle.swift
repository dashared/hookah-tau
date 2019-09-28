//
//  ButtonStyle.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

protocol ButtonStyle: class {
    func apply(to button: Button, withTitle title: String?)
}
