//
//  Date+Utils.swift
//  CalendarView
//
//  Created by Jonathan Pereira Bijos on 18/10/19.
//

import Foundation

extension Date {
    
    var day: Int {
        let myCalendar = self.setUpGregorianCalendar()
        
        let myComponents = (myCalendar as NSCalendar).components(.day, from: self)
        let day = myComponents.day
        return day!
    }
    
    var month: Int {
        let myCalendar = self.setUpGregorianCalendar()
        
        let myComponents = (myCalendar as NSCalendar).components(.month, from: self)
        let month = myComponents.month
        return month!
    }
    
    var year: Int {
        let myCalendar = self.setUpGregorianCalendar()
        
        let myComponents = (myCalendar as NSCalendar).components(.year, from: self)
        let year = myComponents.year
        return year!
    }
    
    var firstDate: Date {
        let calendar = self.setUpGregorianCalendar()
        
        var components = calendar.dateComponents([.month, .year], from: self)
        components.day = 1
        return calendar.date(from: components)!
    }
    
    var lastDate: Date {
        let calendar = self.setUpGregorianCalendar()
        
        var components = calendar.dateComponents([.month, .year], from: self)
        components.day = -1
        return calendar.date(from: components)!
    }
    
    var shortDate: String {
        return String(format: "%@ %04d", self.month(self.month), self.year)
    }
    
    var firstWeekday: Int {
        let calendar = self.setUpGregorianCalendar()
        
        return calendar.dateComponents([.weekday], from: self).weekday!
    }
    
    var daysInMonth: Int {
        let calendar = self.setUpGregorianCalendar()
        
        return calendar.range(of: .day, in: .month, for: self)!.count
    }
    
    func shortDayOfWeekByDay(_ day : Int, charactersLimit: Int) -> String {
        var dayString = ""
        switch day {
        case 1:
            dayString = "Domingo"
        case 2:
            dayString = "Segunda-feira"
        case 3:
            dayString = "Terça-feira"
        case 4:
            dayString = "Quarta-feira"
        case 5:
            dayString = "Quinta-feira"
        case 6:
            dayString = "Sexta-feira"
        case 7:
            dayString = "Sábado"
        default: break
        }
       
        return String(dayString.prefix(charactersLimit))
    }
    
    func month(_ month : Int) -> String{
        switch month {
        case 1:
            return "janeiro"
        case 2:
            return "fevereiro"
        case 3:
            return "março"
        case 4:
            return "abril"
        case 5:
            return "maio"
        case 6:
            return "junho"
        case 7:
            return "julho"
        case 8:
            return "agosto"
        case 9:
            return "setembro"
        case 10:
            return "outubro"
        case 11:
            return "novembro"
        case 12:
            return "dezembro"
            
        default: break
        }
        return ""
    }
    
    func equalsDay(date: Date) -> Bool {
        let calendar = self.setUpGregorianCalendar()
        return calendar.compare(self, to: date, toGranularity: .day) == ComparisonResult.orderedSame
    }
    
    func setUpGregorianCalendar() -> Calendar {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        return calendar
    }
    
    mutating func setHour(with hour: Int) {
        let calendar = self.setUpGregorianCalendar()
        var components = calendar.dateComponents([.day, .month, .year], from: self)
        components.hour = hour
        self = calendar.date(from: components)!
    }
}

