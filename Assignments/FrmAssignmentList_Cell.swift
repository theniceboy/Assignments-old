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
    @IBOutlet weak var lbPriority: UILabel!
    
    var btnChecked: TKAnimatedCheckButton!
    
    var btnCheckNotAddYet = true
    
    func configureView() {
        if (btnCheckNotAddYet) {
            btnChecked = TKAnimatedCheckButton (frame: CGRect(x: 20, y: 20, width: 35, height: 35))
            btnChecked.addTarget(self, action: #selector(FrmAssignmentList_Cell.btnCheckTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btnChecked.color = csystemdarkgray.CGColor
            btnChecked.skeletonColor = clightgray.CGColor
            vMain.addSubview(btnChecked)
            btnCheckNotAddYet = false
        }
        if ((assignment?.completed)! == true) {
            btnChecked.checked = true
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.btnChecked.color = cgreen.CGColor
                self.lbDesc.textColor = UIColor.grayColor()
            })
        } else {
            if (btnChecked.checked) {
                btnChecked.checked = false
            }
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.btnChecked.color = csystemdarkgray.CGColor
                self.lbDesc.textColor = UIColor.blackColor()
            })
        }
        lbDesc.text = assignment?.desc
        lbClass.text = assignment!.fromClass
        lbAssignmentType.text = assignmentType[(assignment?.assignmentType)!]
        lbPriority.text = priorityType[(assignment?.priority)!]
    }
    
    @IBAction func btnCheckTapped(sender: AnyObject) {
        if (btnChecked.checked) {
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.btnChecked.color = csystemdarkgray.CGColor
                self.lbDesc.textColor = UIColor.blackColor()
            })
        } else {
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.btnChecked.color = cgreen.CGColor
                self.lbDesc.textColor = UIColor.grayColor()
            })
        }
        btnChecked.checked = !btnChecked.checked
        assignment?.completed = !(assignment?.completed)!
        saveSystemAssignments()
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
