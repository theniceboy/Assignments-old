//
//  FrmNewAssignment.swift
//  Assignments
//
//  Created by David Chen on 9/5/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import UIKit

class FrmNewAssignment: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, WWCalendarTimeSelectorProtocol {
    
    // MARK: - IBOutlets

    @IBOutlet weak var tfDesc: SkyFloatingLabelTextField!
    @IBOutlet weak var lbNotes: UILabel!
    @IBOutlet weak var tvNotes: UITextView!
    @IBOutlet weak var lbDueDate_Day: UILabel!
    @IBOutlet weak var cvScrollView: UIScrollView!
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var pType: UIPickerView!
    @IBOutlet weak var lbAssignmentType: UILabel!
    @IBOutlet weak var pReminder: UIPickerView!
    @IBOutlet weak var blurReminder: UIVisualEffectView!
    @IBOutlet weak var sReminder: UISwitch!
    @IBOutlet weak var vReminderBlocker: UIView!
    @IBOutlet weak var pClass: UIPickerView!
    @IBOutlet weak var pRepeat: UIPickerView!
    @IBOutlet weak var vDueTime: UIView!
    @IBOutlet weak var btnDueTime: ZFRippleButton!
    @IBOutlet weak var lbDueTime: UILabel!
    
    // MARK: - Variables & Constants
    
    let reminderType: [String] = ["Night before", "2 nights Before", "3 Nights Before", "Date due", "Custom"]
    let repeatType: [String] = ["Everyday", "Every week", "Every 2 weeks", "Custom"]
    var superDUEDATE: NSDate = NSDate()
    var dueDate: NSDate = NSDate(), dueTime: NSDate = NSDate()
    // Constraints
    var c1: NSLayoutConstraint!
    var cSetAlready: Bool = false
    var currentWWCPicker: String = ""
    var formChecked: Bool = false
    
    // MARK: - UI
    
    func initViews() {
        if (!cSetAlready) {
            c1 = NSLayoutConstraint(item: btnDueTime, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.vDueTime, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
            vMain.addConstraint(c1)
            vMain.layoutIfNeeded()
            cSetAlready = true
        }
    }
    
    func showClearTimeButton () {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.c1.constant = -70
            self.vDueTime.layoutIfNeeded()
            }, completion: nil)
    }
    
    func hideClearTimeButton () {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.c1.constant = 0
            self.vDueTime.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])! // Tomorrow
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: dueDate)
        let date: Date = Date(year : components.year, month : components.month, day : components.day)
        lbDueDate_Day.text = "Due " + dateToString(date)
        cvScrollView.contentSize = CGSize(width: vMain.bounds.width, height: 800)
        
        // Delegates
        pType.delegate = self
        pType.dataSource = self
        pReminder.delegate = self
        pReminder.dataSource = self
        pClass.delegate = self
        pClass.dataSource = self
        pRepeat.delegate = self
        pRepeat.dataSource = self
        tvNotes.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        initViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(FrmNewAssignment.settingsBGTapped(_:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.window!.addGestureRecognizer(tapBGGesture)
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
            return 5
        } else if (pickerView == pClass) {
            return classes.count
        } else if (pickerView == pRepeat) {
            return 4
        } else {
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == pType) {
            return assignmentType[row]
        } else if (pickerView == pReminder) {
            return reminderType[row]
        } else if (pickerView == pClass) {
            return classes[row].name
        } else if (pickerView == pRepeat) {
            return repeatType[row]
        } else {
            return "a"
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == pType) {
            lbAssignmentType.text = "Assignment Type : " + assignmentType[row]
        } else if (pickerView == pReminder) {
            
        } else if (pickerView == pClass) {
            if (row == classes.count) {
                
            }
        } else if (pickerView == pRepeat) {
            /*
            if（row == repeatType.count) {
                return 0
            }
 */
        }
    }
    
    // MARK: - UITextView
    
    func textViewDidChange(textView: UITextView) {
        self.lbNotes.hidden = (self.tvNotes.text != "")
    }
    
    // MARK: - tapGestures
    
    var tapBGGesture: UITapGestureRecognizer!
    
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
    
    @IBAction func tfDesc_EditingChanged(sender: AnyObject) {
        if (formChecked) {
            tfDesc_Check()
        }
    }
    
    @IBAction func btnClose_Tapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tfDesc_Check () -> Bool {
        if (tfDesc.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count == 0) {
            tfDesc.errorMessage = "Short description cannot be empty"
            return false
        }
        tfDesc.errorMessage = ""
        return true
    }
    
    func checkField () -> Bool {
        formChecked = true
        if (tfDesc_Check() == false) {
            return false
        }
        return true
    }
    
    @IBAction func btnAdd_Tapped(sender: AnyObject) {
        if (checkField()) {
            let newAssignment: Assignment = Assignment()
            newAssignment.desc = tfDesc.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            curFrmAssignmentList.convertTable()
            curFrmAssignmentList.tableView.reloadData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func btnDatePicker_Tapped(sender: AnyObject) {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionCurrentDate = nstoday()
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(false)
        selector.optionCurrentDate = dueDate
        presentViewController(selector, animated: true, completion: nil)
        currentWWCPicker = "Date"
    }
    
    @IBAction func btnDueTime_Tapped(sender: AnyObject) {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionCurrentDate = nstoday()
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        selector.optionCurrentDate = dueTime
        presentViewController(selector, animated: true, completion: nil)
        currentWWCPicker = "Time"
    }
    
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        if (currentWWCPicker == "Date") {
            dueDate = date
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            let dt: Date = Date(year : components.year, month : components.month, day : components.day)
            lbDueDate_Day.text = "Due " + dateToString(dt)
            if (Date.today() >= dt) {
                lbDueDate_Day.textColor = cred
            } else {
                lbDueDate_Day.textColor = cblue
            }
        } else if (currentWWCPicker == "Time") {
            dueDate = date
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Hour , .Minute], fromDate: date)
            lbDueTime.text = "Deadline at \(components.hour):\(components.minute)"
            btnDueTime.setTitle("Repick Due Time", forState: .Normal)
            showClearTimeButton()
        }
    }
    
    @IBAction func btnClearTime(sender: AnyObject) {
        hideClearTimeButton()
        lbDueTime.text = "No specific time"
        btnDueTime.setTitle("Pick Due Time (Optional)", forState: .Normal)
    }
    
    @IBAction func btnAddClass_Tapped(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Name of the class")
        alert.addButton("Create") {
            let txtTrimmed: String = txt.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if (txtTrimmed.characters.count == 0) {
                SCLAlertView().showError("Name cannot be empty", subTitle: "", closeButtonTitle:"OK")
            }
            let newClass: Class = Class()
            newClass.name = txtTrimmed
            classes.append(newClass)
            self.pClass.reloadAllComponents()
        }
        alert.addButton("Cancel") { 
            //
        }
        alert.showEdit("Add a new Class", subTitle: "")
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
