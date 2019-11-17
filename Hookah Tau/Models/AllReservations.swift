//
//  AllReservations.swift
//  Hookah Tau
//
//  Created by cstore on 15/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct AllReservations: MyCodable {
    var reservations: [Int: [Date: [ReservationPeriod]]]
    var intervals: [String: [Date: [Int]]]
}

struct ReservationPeriod: MyCodable {
    var startTime: String
    var duration: Int
}
