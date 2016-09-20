//
//  Classes.swift
//  Assignments
//
//  Created by David Chen on 9/12/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import Foundation
import UIKit

// General Assignments
class Class {
    var name: String = ""
    var period: Int = 0
    
    func setData (_name: String, _period: Int) {
        name = _name
        period = _period
    }
    
    init () {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        if let _name = aDecoder.decodeObjectForKey("name") as? String { self.name = _name }
        if let _period = aDecoder.decodeIntegerForKey("period") as? Int { self.period = _period }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeInteger(period, forKey: "period")
    }
}

func saveSystemClasses () {
    NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(classes), forKey: "classes")
    NSUserDefaults.standardUserDefaults().synchronize()
}