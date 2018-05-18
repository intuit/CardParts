//
//  Date.swift
//  Turbo
//
//  Created by Roossin, Chase on 11/21/17.
//  Copyright © 2017 Intuit, Inc. All rights reserved.
//

enum DateFormat : String {
    case Date = "yyyy'-'MM'-'dd'", DateAndTime = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ", CreditDateAndTime = "yyyy-MM-dd'T'HH:mm:ss.sssZ", CreditShortDateAndTime = "MMMM yyyy", DateSlashes  = "MM/dd/yyyy", abbreviatedMonth = "MMM YYYY", abbreviatedMonthIncludeDate = "MMM d, YYYY"
}

extension Date {
    
    var numberOfDaysThisMonth: Int {
        let calendar = Calendar.current
        if let numberOfDays = calendar.range(of: .day, in: .month, for: self) {
            return numberOfDays.count
        }
        return day
    }
    
    var day: Int {
        let calendar = Calendar.current
        return (calendar as NSCalendar).component(.day, from: self)
    }
    
    var month: Int? {
        let components = Calendar.current.dateComponents([.month], from: self)
        return components.month
    }
    
    var year: Int? {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year
    }
    
    static func parseDateFromString(_ date: String, format : DateFormat = .Date) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        
        if let date = dateFormatter.date(from: date) {
            return date
        }
        else {
            dateFormatter.dateFormat = DateFormat.DateAndTime.rawValue
            return dateFormatter.date(from: date)
        }
    }
    
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func toString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toString(withFormat format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    func isInYear(_ year: Int) -> Bool {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year == year
    }
}
