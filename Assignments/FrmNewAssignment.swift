//
//  FrmNewAssignment.swift
//  Assignments
//
//  Created by David Chen on 9/5/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import UIKit

class FrmNewAssignment: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - IBOutlets

    @IBOutlet weak var lbNotes: UILabel!
    @IBOutlet weak var tvNotes: UITextView!
    @IBOutlet weak var dpDueDate: UIDatePicker!
    @IBOutlet weak var lbDueDate_Day: UILabel!
    @IBOutlet weak var cvScrollView: UIScrollView!
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var pType: UIPickerView!
    @IBOutlet weak var lbAssignmentType: UILabel!
    @IBOutlet weak var pReminder: UIPickerView!
    @IBOutlet weak var blurReminder: UIVisualEffectView!
    @IBOutlet weak var sReminder: UISwitch!
    @IBOutlet weak var vReminderBlocker: UIView!
    
    // MARK: - Variables & Constants
    
    let assignmentType: [String] = ["Homework", "Quiz & Test", "Project", "Presentation", "Study", "Others"]
    let reminderType: [String] = ["Night before", "2 Nights Before", "3 Nights Before", "Date due"]
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dpDueDate.date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])! // Tomorrow
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: dpDueDate.date)
        let date: Date = Date(year : components.year, month : components.month, day : components.day)
        lbDueDate_Day.text = "Due " + dateToString(date)
        cvScrollView.contentSize = CGSize(width: vMain.bounds.width, height: 800)
        
        // UIPicker
        pType.delegate = self
        pType.dataSource = self
        pReminder.delegate = self
        pReminder.dataSource = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.window!.removeGestureRecognizer(tapBGGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPickerView
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == pType) {
            return 6
        } else if (pickerView == pReminder) {
            return 4
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == pType) {
            return assignmentType[row]
        } else if (pickerView == pReminder) {
            return reminderType[row]
        } else {
            return ""
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == pType) {
            lbAssignmentType.text = "Assignment Type : " + assignmentType[row]
        } else if (pickerView == pReminder) {
            
        }
    }
    
    // MARK: - tapGestures
    
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
    
    // MARK: - IBActions
    
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
    
    @IBAction func sReminder_ValueChanged(sender: AnyObject) {
        let alpha: CGFloat = (sReminder.on ? 0 : 0.8)
        vReminderBlocker.hidden = sReminder.on
        UIView.animateWithDuration(0.5) {
            self.blurReminder.alpha = alpha
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
