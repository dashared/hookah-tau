//
//  Extensions+Date.swift
//  Hookah Tau
//
//  Created by cstore on 16/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct IntervalDate {
    var day: Int
    var month: Int
    var year: Int
    
    var minutes: Int? = nil
}

extension IntervalDate {
    func getFullString() -> String {
        var result = getDateString()
        if let min = minutes {
            result += "T\(min * 10 / 60 + 12):\(min * 10 % 60):00Z"
        }
        return result
    }
    
    func getDateString() -> String {
        return "\(year)-\(month)-\(day)"
    }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
  }()
}


extension Date {
    static func getNext(days: Int) -> [IntervalDate] {
        var result = [IntervalDate]()
        
        var date = Date()
        let calendar = Calendar.current
        
        for _ in 1...days {
            let appendingResult = IntervalDate(day: calendar.component(.day, from: date),
                                               month: calendar.component(.month, from: date),
                                               year: calendar.component(.year, from: date))
            result.append(appendingResult)
            
            let newDate = calendar.date(byAdding: .day, value: 1, to: date)
            guard let nextDate = newDate else { break }
            date = nextDate
        }
        
        return result
    }
    
    static func getDateFromCurrent(days: Int = 0, period: Int? = nil) -> IntervalDate? {
        let date = Date()
        let calendar = Calendar.current
        
        let newDate = calendar.date(byAdding: .day, value: days, to: date)
        guard let nextDate = newDate else { return nil }
        
        return IntervalDate(day: calendar.component(.day, from: nextDate),
                            month: calendar.component(.month, from: nextDate),
                            year: calendar.component(.year, from: nextDate),
                            minutes: period)
    }
}
