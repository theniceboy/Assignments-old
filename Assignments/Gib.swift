//
//  Gib.swift
//  Assignments
//
//  Created by David Chen on 9/4/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import Foundation
import UIKit

// General Assignments
class Classes {
    var name: String = ""
    var period: Int = 0
}

// Colors
let cred = UIColor (red: 208 / 255, green: 2 / 255, blue: 27 / 255, alpha: 1.0)
let cgreen = UIColor (red: 126 / 255, green: 211 / 255, blue: 33 / 255, alpha: 1.0)
let cblue = UIColor (red: 67 / 255, green: 146 / 255, blue: 239 / 255, alpha: 1.0)
let cblue_light = UIColor (red: 67 / 255, green: 146 / 255, blue: 239 / 255, alpha: 0.9)
let clightgray = UIColor (red: 239 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1.0)
let cdarkgray = UIColor (red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1.0)
let csystemdarkgray = UIColor (red: 85 / 255, green: 85 / 255, blue: 85 / 255, alpha: 1.0)


class Assignment {
    var desc: String = "", from: String = "", note: String = "", duedate: Date = Date(), repeattype: Int = 0
    
    func newAssignment (desc: String, from: String, note: String, duedate: Date, repeattype: Int) {
        let assignment = Assignment()
        assignment.desc = desc
        assignment.from = from
        assignment.note = note
        assignment.duedate = duedate
        assignment.repeattype = repeattype
        assignments.append(assignment)
    }
}

var assignments: [Assignment] = []

/*
 repeattype
 */