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
    
    func exportClientsToCSV(_ arr: [Client]) -> String {
        return arr.reduce(Client.csvHeading) { return funcToMapClientsIntoString($0, $1) }
    }
    
    /// Filtering function to get every periods which intersects with given date
    /// - Parameter periods: all periods of bookings (for a particular table)
    /// - Parameter today: date
    func filterPeriodsInDate(_ periods: [ReservationPeriod], _ today: Date) -> [ReservationPeriod] {
        return periods.filter(filterPeriod(today))
    }
    
    
    /// Filtering func to get every intersecting period for the table. Useful for 2nd booning screen
    /// - Parameter periods: Periods for the table
    /// - Parameter start: for client 12:00, for admin t - 24h
    /// - Parameter end: for client 3:00, for admin t + 24h
    func filterPeriodsStartEndDates(_ periods: [ReservationPeriod], _ start: Date, _ end: Date) -> [ReservationPeriod] {
        return periods.filter(filterInInterval(start, end))
    }
    
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
    
    private func filterInInterval(_ start: Date, _ end: Date) -> ((ReservationPeriod) -> Bool) {
        
        let dateInterval = DateInterval(start: start, end: end)
        func intervalChecking(_ sp: Date, _ ep: Date) -> Bool {
            let innerInterval = DateInterval(start: sp, end: ep)
            
            return dateInterval.intersects(innerInterval)
        }
        
        return { (period: ReservationPeriod) in intervalChecking(period.startTime, period.endTime) }
    }
    
    private func funcToMapClientsIntoString(_ acc: String, _ el: Client) -> String {
        return acc + el.toString + "\n"
    }
}
