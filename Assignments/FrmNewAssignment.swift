//
//  FrmNewAssignment.swift
//  Assignments
//
//  Created by David Chen on 9/5/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import UIKit

class FrmNewAssignment: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var lbNotes: UILabel!
    @IBOutlet weak var tvNotes: UITextView!
    @IBOutlet weak var dpDueDate: UIDatePicker!
    @IBOutlet weak var lbDueDate_Day: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dpDueDate.date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])! // Tomorrow
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: dpDueDate.date)
        let date: Date = Date(year : components.year, month : components.month, day : components.day)
        lbDueDate_Day.text = "Due " + dateToString(date)
    }
    
    var tapBGGesture: UITapGestureRecognizer!
    override func viewDidAppear(animated: Bool) {
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(FrmNewAssignment.settingsBGTapped(_:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.window!.addGestureRecognizer(tapBGGesture)
    }
    
    
    
    
    func settingsBGTapped(sender: UITapGestureRecognizer) {
        /*
        if (sender.state == UIGestureRecognizerState.Ended) {
            let presentedView = presentedViewController!.view
            print(sender.locationInView(presentedView))
            print(presentedView.bounds)
            if (!CGRectContainsPoint(presentedView!.bounds, sender.locationInView(presentedView))) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                })
            }
        }
        */
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.window!.removeGestureRecognizer(tapBGGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClose_Tapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnAdd_Tapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func dpDueDate_ValueChanged(sender: AnyObject) {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: dpDueDate.date)
        let date: Date = Date(year : components.year, month : components.month, day : components.day)
        lbDueDate_Day.text = "Due " + dateToString(date)
        if (Date.today() >= date) {
            lbDueDate_Day.textColor = cred
        } else {
            lbDueDate_Day.textColor = cblack
        }
        //    print(dateToString(date))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
