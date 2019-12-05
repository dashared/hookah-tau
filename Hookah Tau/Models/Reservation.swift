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
