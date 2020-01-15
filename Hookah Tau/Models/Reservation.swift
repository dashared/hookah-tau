//
//  Reservation.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation


struct Reservation: MyCodable {
    
    var uuid: String
    var establishment: Int
    var startTime: Date
    var endTime: Date
    var numberOfGuests: Int
    var reservedTable: Int
    
    init(uuid: String, reservationData: ReservationData) {
        self.uuid = uuid
        self.establishment = reservationData.establishment
        self.startTime = reservationData.startTime
        self.endTime = reservationData.endTime
        self.numberOfGuests = reservationData.numberOfGuests
        self.reservedTable = reservationData.reservedTable
    }
    
    init(uuid: String, establishment: Int, startTime: Date, endTime: Date, numberOfGuests: Int, reservedTable: Int) {
        self.uuid = uuid
        self.establishment = establishment
        self.startTime = startTime
        self.endTime = endTime
        self.numberOfGuests = numberOfGuests
        self.reservedTable = reservedTable
    }
}

/// `Reservation` without `uuid`
struct ReservationData: MyCodable {
    
    var establishment: Int
    var startTime: Date
    var endTime: Date
    var numberOfGuests: Int
    var reservedTable: Int
   
}

/// Структура для получения респонса на `GET /admin/reservations/{establishment id}`
struct ReservationWithUser: MyCodable {
    
    var uuid: String?
    var establishment: Int
    var startTime: Date
    var endTime: Date
    var numberOfGuests: Int
    var reservedTable: Int
    var owner: FullUser
    
    init(reservation: Reservation, user: FullUser) {
        self.uuid = reservation.uuid
        self.establishment = reservation.establishment
        self.startTime = reservation.startTime
        self.endTime = reservation.endTime
        self.numberOfGuests = reservation.numberOfGuests
        self.reservedTable = reservation.reservedTable
        self.owner = user
    }
    
    init(uuid: String?, establishment: Int, startTime: Date, endTime: Date, numberOfGuests: Int, reservedTable: Int, owner: FullUser) {
        self.uuid = uuid
        self.establishment = establishment
        self.startTime = startTime
        self.endTime = endTime
        self.numberOfGuests = numberOfGuests
        self.reservedTable = reservedTable
        self.owner = owner
    }
}

struct AdminCreateReservation: MyCodable {
    var reservation: ReservationData
    var user: String
}

