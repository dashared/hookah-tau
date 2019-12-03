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

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
      formatter.timeZone = TimeZone(abbreviation: "UTC")
      return formatter
    }()
    
    static let dmy: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      formatter.timeZone = TimeZone(abbreviation: "UTC")
      return formatter
    }()
}


extension Date {
    static func getNext(days: Int) -> [Date] {
        var result = [Date]()
        
        var date = Date()
        let calendar = Calendar.current
        
        for _ in 1...days {
            result.append(date)
            
            let newDate = calendar.date(byAdding: .day, value: 1, to: date)
            guard let nextDate = newDate else { break }
            date = nextDate
        }
        
        return result
    }
    
    static func getDateFromCurrent(days: Int = 0, periods: Int? = nil) -> Date? {
        let date = Date()
        
        let utcDate = date.getUTCDate()
        
        let newDate = Calendar.current.date(byAdding: .day, value: days, to: utcDate)
        
        // case if periods are important
        if let minutes = periods, let date = newDate {
            return date.changeTime(periods: minutes)
        }
        
        return newDate
    }
    
    /// Get UTC format of date
    func getUTCDate() -> Date {
        let calendar = Calendar.current
        
        let day = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
            
        var dateCalendars = DateComponents()
        dateCalendars.hour = day.hour!
        dateCalendars.minute = day.minute!
        dateCalendars.day = day.day!
        dateCalendars.month = day.month!
        dateCalendars.year = day.year!
        dateCalendars.timeZone = TimeZone(abbreviation: "GMT")
        
        return Calendar.current.date(from: dateCalendars)!
    }
    
    func changeTime(periods: Int) -> Date? {
        let hours = (periods * 10 / 60) % 24
        let min = (periods * 10) % 60

        return self.set(hours: hours, minutes: min, seconds: 0)
    }
    
    func getDay() -> Int {
        let day = Calendar.current.dateComponents([.day], from: self)
        return day.day ?? 0
    }
    
    func getDMY() -> Date {
        return set(hours: 0, minutes: 0, seconds: 0)!
    }
    
    func addHours(_ h: Int) -> Date {
        return self.addingTimeInterval(Double(h) * 60.0 * 60.0)
    }
    
    func addPeriods(_ p: Int) -> Date {
        let h = (p * 10 / 60) % 24
        let m = (p * 10) % 60
        
        return self.addingTimeInterval(Double(h) * 60.0 * 60.0 + Double(m) * 60.0)
    }
 
    func set(hours: Int, minutes: Int, seconds: Int) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let newDateString = "\(dateFormatter.string(from: self)) \(hours):\(minutes):\(seconds)"

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.date(from: newDateString)
    }
    
    func getMinutesPeriods(fromStart startDate: Date) -> Int {
        let diffInMins = Calendar.current.dateComponents([.minute], from: startDate, to: self).minute!
        let periods = diffInMins / 10
        return periods
    }
    
    func getPrevCurrentNextMonth() -> (String, String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "LLLL"
        let current = dateFormatter.string(from: self)
        
        let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: self)!
        let next = dateFormatter.string(from: nextDate)
        
        let prevDate = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        let prev = dateFormatter.string(from: prevDate)
        
        print("\(prevDate) \(self) \(nextDate)")
        return (prev, current, next)
    }
}

// MARK: - Admin vs Client

extension Date {
    
    /// Идем на день назад, чтобы найти точку начала с которой может забронировать администратор
    func getAdminStartingAndEndPoint() -> (Date, Date) {
        let utcDate = self.getUTCDate()
        
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: utcDate)!
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: utcDate)!
        
        return (startDate, endDate)
    }
    
    func getAdminsStartingPoint() -> Int {
        let comp = Calendar.current.dateComponents([.hour, .minute], from: self)
        return (comp.hour! * 6 + comp.minute! / 10)
    }
    
    func getClientStartingAndEndPoint() -> (Date, Date) {
        // час
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let hour = calendar.dateComponents([.hour], from: self).hour!
        
        if hour >= 0 && hour <= 3 { // [ 00:00 ... 3:00 ]
            let endDate = self.set(hours: 3, minutes: 0, seconds: 0)! // 3 00
            let start = calendar.date(byAdding: .day, value: -1, to: self)!
            let startDate = start.set(hours: 12, minutes: 0, seconds: 0)! // 12 00
            
            return (startDate, endDate)
        } else { // [12:00 ... 23:50]
            let startDate = self.set(hours: 12, minutes: 0, seconds: 0)! // 12 00
            let end = calendar.date(byAdding: .day, value: 1, to: self)!
            let endDate = end.set(hours: 3, minutes: 0, seconds: 0)! // 3 00
            
            return (startDate, endDate)
        }
    }
}

extension Date {
    static func format(_ startDate: Date, _ endDate: Date) -> (date: String, time: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")

        let dateStr = "\(dateFormatter.string(from: startDate))"
        
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = "\(dateFormatter.string(from: startDate)) — \(dateFormatter.string(from: endDate))"
        
        return (dateStr, timeStr)
    }
}
