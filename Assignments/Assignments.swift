//
//  Assignments.swift
//  Assignments
//
//  Created by David Chen on 9/4/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import Foundation
import UIKit

let assignmentType: [String] = ["Homework", "Quiz / Test", "Project", "Presentation", "Study", "Others"]

class Assignment : NSObject, NSCoding {
    var desc: String = "", fromClass: String = "", note: String = "", dueDate: NSDate = NSDate(), opTime: Bool = false, repeatType: Int = 0, assignmentType: Int = 0, completed: Bool = false
    var reminder: NSDate = NSDate()
    var nid: Int = 0 // Notification ID
    
    func setData (_desc: String, _fromClass: String, _note: String, _duedate: NSDate, _opTime: Bool, _repeatType: Int, _assignmentType: Int, _reminder: NSDate, _nid: Int) {
        desc = _desc
        fromClass = _fromClass
        note = _note
        dueDate = _duedate
        opTime = _opTime
        repeatType = _repeatType
        assignmentType = _assignmentType
        reminder = _reminder
        nid = _nid
    }
    
    override init () {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        if let _desc = aDecoder.decodeObjectForKey("desc") as? String { self.desc = _desc }
        if let _fromClass = aDecoder.decodeObjectForKey("fromClass") as? String { self.fromClass = _fromClass }
        if let _note = aDecoder.decodeObjectForKey("note") as? String { self.note = _note }
        if let _dueDate = aDecoder.decodeObjectForKey("dueDate") as? NSDate { self.dueDate = _dueDate }
        if let _opTime = aDecoder.decodeBoolForKey("opTime") as? Bool { self.opTime = _opTime }
        if let _repeatType = aDecoder.decodeIntegerForKey("repeatType") as? Int { self.repeatType = _repeatType }
        if let _assignmentType = aDecoder.decodeIntegerForKey("assignmentType") as? Int { self.assignmentType = _assignmentType }
        if let _completed = aDecoder.decodeBoolForKey("completed") as? Bool { self.completed = _completed }
        if let _reminder = aDecoder.decodeObjectForKey("reminder") as? NSDate { self.reminder = _reminder }
        if let _nid = aDecoder.decodeIntegerForKey("nid") as? Int { self.nid = _nid }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(desc, forKey: "desc")
        aCoder.encodeObject(fromClass, forKey: "fromClass")
        aCoder.encodeObject(note, forKey: "note")
        aCoder.encodeObject(dueDate, forKey: "duedate")
        aCoder.encodeObject(opTime, forKey: "opTime")
        aCoder.encodeInteger(repeatType, forKey: "repeatType")
        aCoder.encodeInteger(repeatType, forKey: "assignmentType")
        aCoder.encodeBool(completed, forKey: "completed")
        aCoder.encodeObject(reminder, forKey: "reminder")
        aCoder.encodeInteger(nid, forKey: "nid")
    }
}

func saveSystemAssignments () {
    NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(assignments), forKey: "assignments")
    NSUserDefaults.standardUserDefaults().synchronize()
}

