//
//  HFunc.swift
//  Hookah Tau
//
//  Created by cstore on 02/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation


class HFunc {
    
    private init() {}
    
    static let main = HFunc()
    
    private func filterPeriod(_ today: Date) -> ((ReservationPeriod) -> Bool) {
        func datePredicate(_ start: Date, _ end: Date, _ current: Date) -> Bool  {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "GMT")!
            
            let result = calendar.isDate(start, equalTo: current, toGranularity: .day)
                || calendar.isDate(end, equalTo: current, toGranularity: .day)
            
            return result
        }
        
        return { (period: ReservationPeriod) in datePredicate(period.startTime, period.endTime, today) }
    }
    
    
    /// Filtering function to get every periods which intersects with given date
    /// - Parameter periods: all periods of bookings (for a particular table)
    /// - Parameter today: date
    func filterPeriodsInDate(_ periods: [ReservationPeriod], _ today: Date) -> [ReservationPeriod] {
        return periods.filter(filterPeriod(today))
    }
}
