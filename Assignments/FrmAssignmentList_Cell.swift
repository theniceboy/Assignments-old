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
    var btnChecked: TKAnimatedCheckButton!
    
    var btnCheckNotAddYet = true
    
    func configureView() {
        if (btnCheckNotAddYet) {
            btnChecked = TKAnimatedCheckButton (frame: vTk.frame)
            btnChecked.addTarget(self, action: #selector(FrmAssignmentList_Cell.btnCheckTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btnChecked.color = cblue.CGColor
            btnChecked.skeletonColor = clightgray.CGColor
            vMain.addSubview(btnChecked)
            btnCheckNotAddYet = false
        }
    }
    
    @IBAction func btnCheckTapped(sender: AnyObject) {
        if (btnChecked.checked) {
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.btnChecked.color = cblue.CGColor
            })
        } else {
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.btnChecked.color = cgreen.CGColor
            })
        }
        btnChecked.checked = !btnChecked.checked
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
