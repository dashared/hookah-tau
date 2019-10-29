//
//  UserModel.swift
//  Hookah Tau
//
//  Created by cstore on 19/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct User: MyCodable {
    var name: String
    var phoneNumber: String
    var isAdmin: Bool
}
