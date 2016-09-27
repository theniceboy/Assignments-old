//
//  Int+Timepiece.swift
//  Timepiece
//
//  Created by Naoto Kaneko on 2014/08/15.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

extension Int {
    var year: Duration {
        return Duration(value: self, unit: .Year)
    }
    
    var month: Duration {
        return Duration(value: self, unit: .Month)
    }
    
    var week: Duration {
        return Duration(value: self, unit: .WeekOfYear)
    }
    
    var day: Duration {
        return Duration(value: self, unit: .Day)
    }
    
    var hour: Duration {
        return Duration(value: self, unit: .Hour)
    }
    
    var minute: Duration {
        return Duration(value: self, unit: .Minute)
    }
    
    var second: Duration {
        return Duration(value: self, unit: .Second)
    }
        
    var ordinal: String {
        
        let ones: Int = self % 10
        let tens: Int = (self/10) % 10
        
        if (tens == 1) {
            return "th"
        }
        else if (ones == 1) {
            return "st"
        }
        else if (ones == 2) {
            return "nd"
        }
        else if (ones == 3) {
            return "rd"
        }
        return "th"
    }
}
