//
//  UserModel.swift
//  Hookah Tau
//
//  Created by cstore on 19/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

/// Используется в запросах при регистрации пользователя
struct User: MyCodable {
    var name: String
    var phoneNumber: String
    var isAdmin: Bool
}

/// При запросах на список пользователей в аккаунте администратора.
struct FullUser: MyCodable {
    var uuid: String
    var name: String?
    var phoneNumber: String
    var isAdmin: Bool
}

/// `GET /admin/clients`
struct Client: MyCodable {
    var uuid: String
    var name: String?
    var phoneNumber: String
    var isAdmin: Bool
    var reservationCount: Int
}
