//
//  NSDate+Timepiece.swift
//  Timepiece
//
//  Created by Naoto Kaneko on 2014/08/16.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation
import ObjectiveC

// MARK: - Calculation

func + (lhs: NSDate, rhs: Duration) -> NSDate {
    return NSCalendar.currentCalendar().dateByAddingDuration(rhs, toDate: lhs, options: .SearchBackwards)!
}

func - (lhs: NSDate, rhs: Duration) -> NSDate {
    return NSCalendar.currentCalendar().dateByAddingDuration(-rhs, toDate: lhs, options: .SearchBackwards)!
}

func - (lhs: NSDate, rhs: NSDate) -> NSTimeInterval {
    return lhs.timeIntervalSinceDate(rhs)
}

// MARK: - Equatable

//extension NSDate: Equatable {}

func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqualToDate(rhs)
}

// MARK: - Comparable

//internal extension NSDate: Comparable {}
//
//func < (lhs: NSDate, rhs: NSDate) -> Bool {
//    return lhs.compare(rhs) == .OrderedAscending
//}

// MARK: -

extension NSDate {
    private struct AssociatedKeys {
        static var TimeZone = "timepiece_TimeZone"
    }
    
    // MARK: - Get components
    /*
    var year: Int {
        return components.year
    }
    
    var month: Int {
        return components.month
    }
    
    var weekday: Int {
        return components.weekday
    }
    
    var day: Int {
        return components.day
    }
    
    var hour: Int {
        return components.hour
    }
    
    var minute: Int {
        return components.minute
    }
    
    var second: Int {
        return components.second
    }
    */
    var timeZone: NSTimeZone {
        return objc_getAssociatedObject(self, &AssociatedKeys.TimeZone) as? NSTimeZone ?? calendar.timeZone
    }
    /*
    private var components: NSDateComponents {
        return calendar.components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: self)
    }
 */
    
    private var calendar: NSCalendar {
        return NSCalendar.currentCalendar()
    }
    
    // MARK: - Initialize
    
    class func date(year year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> NSDate {
        let now = NSDate()
        return now.change(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    class func date(year year: Int, month: Int, day: Int) -> NSDate {
        return NSDate.date(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    }
    
    class func today() -> NSDate {
        let now = NSDate()
        return NSDate.date(year: now.year, month: now.month, day: now.day)
    }
    
    class func yesterday() -> NSDate {
        return nstoday() - 1.day
    }
    
    class func tomorrow() -> NSDate {
        return nstoday() + 1.day
    }
    
    // MARK: - Initialize by setting components
    
    /**
        Initialize a date by changing date components of the receiver.
    */
    func change(year year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> NSDate! {
        let components = self.components
        components.year = year ?? self.year
        components.month = month ?? self.month
        components.day = day ?? self.day
        components.hour = hour ?? self.hour
        components.minute = minute ?? self.minute
        components.second = second ?? self.second
        return calendar.dateFromComponents(components)
    }
    
    /**
        Initialize a date by changing the weekday of the receiver.
    */
    func change(weekday weekday: Int) -> NSDate! {
        return self - (self.weekday - weekday).days
    }
    
    /**
        Initialize a date by changing the time zone of receiver.
    */
    func change(timeZone timeZone: NSTimeZone) -> NSDate! {
        let originalTimeZone = calendar.timeZone
        calendar.timeZone = timeZone
        
        let newDate = calendar.dateFromComponents(components)!
        newDate.calendar.timeZone = timeZone
        objc_setAssociatedObject(newDate, &AssociatedKeys.TimeZone, timeZone, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        calendar.timeZone = originalTimeZone
        
        return newDate
    }
    
    // MARK: - Initialize a date at beginning/end of each units
    
    var beginningOfYear: NSDate {
        return change(month: 1, day: 1, hour: 0, minute: 0, second: 0)
    }
    var endOfYear: NSDate {
        return (beginningOfYear + 1.year).dateByAddingTimeInterval(-1)
    }
    
    var beginningOfMonth: NSDate {
        return change(day: 1, hour: 0, minute: 0, second: 0)
    }
    var endOfMonth: NSDate {
        return (beginningOfMonth + 1.month).dateByAddingTimeInterval(-1)
    }
	
	var beginningOfWeek: NSDate {
        return change(weekday: 1).beginningOfDay
	}
	var endOfWeek: NSDate {
        return (beginningOfWeek + 1.week).dateByAddingTimeInterval(-1)
	}
    
    var beginningOfDay: NSDate {
        return change(hour: 0, minute: 0, second: 0)
    }
    var endOfDay: NSDate {
        return (beginningOfDay + 1.day).dateByAddingTimeInterval(-1)
    }
    
    var beginningOfHour: NSDate {
        return change(minute: 0, second: 0)
    }
    var endOfHour: NSDate {
        return (beginningOfHour + 1.hour).dateByAddingTimeInterval(-1)
    }
    
    var beginningOfMinute: NSDate {
        return change(second: 0)
    }
    var endOfMinute: NSDate {
        return (beginningOfMinute + 1.minute).dateByAddingTimeInterval(-1)
    }
    
    // MARK: - Format dates
    
    func stringFromFormat(format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    // MARK: - Differences
    
    func differenceWith(date: NSDate, inUnit unit: NSCalendarUnit) -> Int {
        
        return calendar.components(unit, fromDate: self, toDate: date, options: []).valueForComponent(unit)
    }
}
