//
//  General.swift
//  Assignments
//
//  Created by David Chen on 9/6/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import Foundation

func nstoday() -> NSDate {
    let date: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(.Second, value: NSTimeZone.localTimeZone().secondsFromGMT, toDate: NSDate(), options: [])!
    return date
}

func dateCounter (d1: Date, d2: Date) -> Int {
    return d2 - d1
}

func dateCounter_FromToday (dt: Date) -> Int {
    return dateCounter(Date.today(), d2: dt)
}

func dateN (dt: Date) -> Int {
    let formatter = NSDateFormatter()
    let month: String = "\((dt.month() > 9 ? "" : "0"))\(dt.month())"
    let day = "\((dt.day() > 9 ? "" : "0"))\(dt.day())"
    formatter.dateFormat = "yyyy-MM-dd"
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let myComponents = myCalendar.components(.Weekday, fromDate: formatter.dateFromString("\(dt.year())-\(month)-\(day)")!)
    let dw = myComponents.weekday
    return dw == 1 ? 7 : dw - 1
}

func dateW (date: Date) -> Int {
    let calendar = NSCalendar.currentCalendar()
    let dtcom = NSDateComponents()
    dtcom.year = date.year()
    dtcom.month = date.month()
    dtcom.day = date.day()
    let dt: NSDate = calendar.dateFromComponents(dtcom)!
    calendar.firstWeekday = 2
    return Int(calendar.components(NSCalendarUnit.WeekOfYear, fromDate: dt).weekOfYear)
}

func nsDateToDate (dt: NSDate) -> Date {
    return Date(year : dt.year, month : dt.month, day : dt.day)
}

func dateToString (dt: Date) -> String {
    //if (date.toString(format: cdf) == unlimited_date_str) {
    //    return "unlimited"
    //}
    //let today = Date.today()
    let uday: Int = dateCounter_FromToday(dt)
    let nday = dateN(dt)
    let advanced_str: String = (abs(uday) > 1 ? (uday > 1 ? "（\(uday) days later）" : "（\(abs(uday)) days ago）") : "")
    if (abs(uday) > 14) {
        return "\(dt.month())/\(dt.day())/\(dt.year())" + advanced_str
    }
    if (abs(uday) < 2) {
        return h_uday[uday]! + advanced_str
    } else if (dateW(dt) == dateW(Date.today())) {
        return h_day[nday]! + advanced_str
    } else if (abs(dateW(dt) - dateW(Date.today())) < 2) {
        var str: String = ""
        if (abs(uday) >= 7 || (uday > 0 && nday < dateN(Date.today())) || (uday < 0 && nday > dateN(Date.today()))) {
            str = ((uday > 0) ? h_week[2] : h_week[0])!
        }
        str += h_day[nday]!
        return str + advanced_str
    }
    return "\(dt.month())/\(dt.day())/\(dt.year())" + advanced_str
}

func nsdateEqual (d1: NSDate, d2: NSDate) -> Bool {
    return (d1.year == d2.year && d1.month == d2.month && d1.day == d2.day) ? true : false
}
