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
    var intervals: [Date: [Date: [Int]]]
    
    enum CodingKeys: CodingKey {
        case reservations
        case intervals
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let intervalsWithStr = try container.decode([String: [String: [Int]]].self, forKey: .intervals)
        let reservationWithStr = try container.decode([String: [String: [ReservationPeriod]]].self, forKey: .reservations)
        
        let resArray = reservationWithStr.map { (element) -> (Int, [Date: [ReservationPeriod]]) in
            let key = Int(element.key) ?? 0
            let valArr = element.value.compactMap { (DateFormatter.dmy.date(from: $0.0)!, $0.1) }
            let val = Dictionary(uniqueKeysWithValues: valArr)
            return (key, val)
        }
        
        let intervArray = intervalsWithStr.map { (element) -> (Date, [Date: [Int]]) in
            let key = DateFormatter.dmy.date(from: element.key)!
            let arr = element.value.compactMap { (DateFormatter.iso8601Full.date(from: $0.0)!, $0.1) }
            let val = Dictionary(uniqueKeysWithValues: arr)
            return (key, val)
        }
        
        intervals = Dictionary(uniqueKeysWithValues: intervArray)
        reservations = Dictionary(uniqueKeysWithValues: resArray)
    }
}

struct ReservationPeriod: MyCodable {
    var startTime: Date
    var duration: Int
}
