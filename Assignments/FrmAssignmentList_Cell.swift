//
//  FrmAssignmentList_Cell.swift
//  Assignments
//
//  Created by David Chen on 9/4/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import UIKit

class FrmAssignmentList_Cell: UITableViewCell {

    var assignment: Assignment? {
        didSet {
            self.configureView()
        }
    }
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var vTk: UIView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbClass: UILabel!
    @IBOutlet weak var lbAssignmentType: UILabel!
    
    var btnChecked: TKAnimatedCheckButton!
    
    var btnCheckNotAddYet = true
    
    func configureView() {
        if (btnCheckNotAddYet) {
            btnChecked = TKAnimatedCheckButton (frame: vTk.frame)
            btnChecked.addTarget(self, action: #selector(FrmAssignmentList_Cell.btnCheckTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btnChecked.color = csystemdarkgray.CGColor
            btnChecked.skeletonColor = clightgray.CGColor
            vMain.addSubview(btnChecked)
            btnCheckNotAddYet = false
        }
        if ((assignment?.completed)! == true) {
            btnChecked.checked = true
        }
        lbDesc.text = assignment?.desc
        lbClass.text = assignment?.fromClass
        lbAssignmentType.text = assignmentType[(assignment?.assignmentType)!]
    }
    
    @IBAction func btnCheckTapped(sender: AnyObject) {
        if (btnChecked.checked) {
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.btnChecked.color = csystemdarkgray.CGColor
            })
        } else {
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.btnChecked.color = cgreen.CGColor
            })
        }
        btnChecked.checked = !btnChecked.checked
        assignment?.completed = !(assignment?.completed)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
