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
    @IBOutlet weak var sReminder: UISwitch!
    @IBOutlet weak var pClass: UIPickerView!
    @IBOutlet weak var sRepeat: UISwitch!
    @IBOutlet weak var pRepeat: UIPickerView!
    @IBOutlet weak var vRepeatBlocker: UIView!
    @IBOutlet weak var blurRepeat: UIVisualEffectView!
    @IBOutlet weak var vDueTime: UIView!
    @IBOutlet weak var btnDueTime: ZFRippleButton!
    @IBOutlet weak var lbDueTime: UILabel!
    @IBOutlet weak var vReminderCustom: UIView!
    @IBOutlet weak var btnReminderCustomDate: ZFRippleButton!
    @IBOutlet weak var btnReminderCustomTime: ZFRippleButton!
    @IBOutlet weak var pPriority: UIPickerView!
    @IBOutlet weak var btnAdd: ZFRippleButton!
    
    // MARK: - Variables & Constants
    
    // General
    var _EDIT: Bool = false, _editAssignment: Assignment = Assignment()
    var curKeyboardHeight: CGFloat = 0
    var scrollHeight: CGFloat = 800
    // dueDate
    var dueDate: NSDate = NSDate(), dueTime: NSDate = NSDate()
    var withSpecificTime: Bool = false
    // Reminder
    var reminderType: [String] = ["Night before", "2 nights Before", "Date due", "Custom"]
    let reminderType_withSpecificTime: [String] = ["Night before", "2 nights Before", "An hour before", "Two hours before", "15 minutes before", "Custom"]
    var reminderCustomDate: NSDate = NSDate(), reminderCustomTime: NSDate = NSDate()
    var reminderPicked: Bool = false
    // Repeat
    let repeatType: [String] = ["Everyday", "Every week", "Every 2 weeks", "Custom"]
    //var superDUEDATE: NSDate = NSDate()
    // Constraints
    var c1: NSLayoutConstraint!, c2: NSLayoutConstraint!
    var cSetAlready: Bool = false
    // WWC
    var currentWWCPicker: String = ""
    // UIPicker
    var cuiType: Int = 0, cuiClass: Int = 0, cuiRepeat: Int = 0, cuiPriority: Int = 0 // Cur pick
    //Final Form Check
    var formChecked: Bool = false
    
    // MARK: - UI
    
    func initViews() {
        if (!cSetAlready) {
            c2 = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: cvScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            self.view.addConstraint(c2)
            
            c1 = NSLayoutConstraint(item: btnDueTime, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.vDueTime, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
            vMain.addConstraint(c1)
            //vMain.layoutIfNeeded()
            self.view.layoutIfNeeded()
            cSetAlready = true
        }
        cvScrollView.contentSize = CGSize(width: 400, height: 700)
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
    
    func setEdit () {
        // Copy Data
        withSpecificTime = _editAssignment.opTime
        dueDate = _editAssignment.dueDate
        
        // Textfields
        tfDesc.text = _editAssignment.desc
        tvNotes.text = _editAssignment.note
        
        // Date Selector
        let dt = nsDateToDate(dueDate)
        lbDueDate_Day.text = "Due " + dateToString(dt)
        if (Date.today() >= dt) {
            lbDueDate_Day.textColor = cred
        } else {
            lbDueDate_Day.textColor = cblue
        }
        if (withSpecificTime) {
            lbDueTime.text = "Deadline at \(dueDate.hour):\(dueDate.minute)"
            btnDueTime.setTitle("Repick Due Time", forState: .Normal)
            withSpecificTime = true
//            pReminder.reloadAllComponents()
            showClearTimeButton()
        }
        
        // Type
        pType.selectRow(_editAssignment.assignmentType, inComponent: 0, animated: true)
        
        // Priority
        pPriority.selectRow(_editAssignment.priority, inComponent: 0, animated: true)
        
        // Class
        for var i in 0 ... classes.count - 1 {
            if (classes[i].name == _editAssignment.fromClass) {
                pClass.selectRow(i, inComponent: 0, animated: true)
                break
            }
        }
        
        // Repeat
        pRepeat.selectRow(_editAssignment.repeatType, inComponent: 0, animated: true)
        
        // Reminder
        reminderCustomDate = _editAssignment.reminder
        reminderCustomTime = _editAssignment.reminder
        updateCustomDateTime(true, updateTime: true)
        
        // UI
        btnAdd.setTitle("    Done    ", forState: .Normal)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dueDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: nstoday(), options: [])! // Tomorrow
        dueDate = nstoday() + 1.days // Tomorrow
        let date: Date = Date(year : dueDate.year, month: dueDate.month, day: dueDate.day)
        lbDueDate_Day.text = "Due " + dateToString(date)
        
        reminderCustomDate = dueDate
        updateCustomDateTime(true, updateTime: true)
        
        // Delegates
        pType.delegate = self
        pType.dataSource = self
//        pReminder.delegate = self
//        pReminder.dataSource = self
        pClass.delegate = self
        pClass.dataSource = self
        pRepeat.delegate = self
        pRepeat.dataSource = self
        tvNotes.delegate = self
        pPriority.delegate = self
        pPriority.dataSource = self
        
        // Keyboard
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        initViews()
        if (_EDIT) {
            setEdit()
        }
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
    
    // MARK: - Keyboard event
    
    func keyboardWillShow (notification: NSNotification) {
        let userInfoDictionary = notification.userInfo
        curKeyboardHeight = ((userInfoDictionary?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size.height)!
        c2.constant = curKeyboardHeight
        UIView.animateWithDuration(0.6) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide (notification: NSNotification) {
        curKeyboardHeight = 0
        c2.constant = 0
        UIView.animateWithDuration(0.6) { 
            self.view.layoutIfNeeded()
        }
    }

    
    // MARK: - UIPickerView
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == pType) {
            return 6
//        } else if (pickerView == pReminder) {
//            return (withSpecificTime ? reminderType_withSpecificTime.count: reminderType.count)
        } else if (pickerView == pClass) {
            return classes.count
        } else if (pickerView == pRepeat) {
            return 4
        } else if (pickerView == pPriority) {
            return 3
        } else {
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == pType) {
            return assignmentType[row]
//        } else if (pickerView == pReminder) {
//            return (withSpecificTime ? reminderType_withSpecificTime[row] :  reminderType[row])
        } else if (pickerView == pClass) {
            return classes[row].name
        } else if (pickerView == pRepeat) {
            return repeatType[row]
        } else if (pickerView == pPriority) {
            return priorityType[row]
        } else {
            return ""
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == pType) {
            cuiType = row
            lbAssignmentType.text = "Assignment Type : " + assignmentType[row]
/*        } else if (pickerView == pReminder) {
            cuiReminder = row
            if ((withSpecificTime ? reminderType_withSpecificTime[row] : reminderType[row]) == "Custom") {
                vReminderCustom.hidden = false
            } else {
                vReminderCustom.hidden = true
            }
 */
        } else if (pickerView == pClass) {
            cuiClass = row
            if (row == classes.count) {
                // Custom ???
            }
        } else if (pickerView == pRepeat) {
            cuiRepeat = row
        } else if (pickerView == pPriority) {
            cuiPriority = row
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
        selector.optionCurrentDate = dueDate
        presentViewController(selector, animated: true, completion: nil)
        currentWWCPicker = "Time"
    }
    
    func updateCustomDateTime(updateDate: Bool, updateTime: Bool) {
        if (updateDate) {
            btnReminderCustomDate.setTitle("\(reminderCustomDate.month)/\(reminderCustomDate.day)/\(reminderCustomDate.year)", forState: .Normal)
        }
        if (updateTime) {
            btnReminderCustomTime.setTitle("\(reminderCustomTime.hour):\(reminderCustomTime.minute)", forState: .Normal)
        }
    }
    
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        if (currentWWCPicker == "Date") {
            dueDate = date
            let dt = nsDateToDate(dueDate)
            lbDueDate_Day.text = "Due " + dateToString(dt)
            if (Date.today() >= dt) {
                lbDueDate_Day.textColor = cred
            } else {
                lbDueDate_Day.textColor = cblue
            }
            if (!reminderPicked) {
                reminderCustomDate = date
            }
            if (vReminderCustom.hidden) {
                updateCustomDateTime(true, updateTime: false)
            }
        } else if (currentWWCPicker == "Time") {
            dueDate = date
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Hour , .Minute], fromDate: date)
            lbDueTime.text = "Deadline at \(components.hour):\(components.minute)"
            btnDueTime.setTitle("Repick Due Time", forState: .Normal)
            withSpecificTime = true
//            pReminder.reloadAllComponents()
            showClearTimeButton()
            if (!reminderPicked) {
                reminderCustomTime = date + 15.minute
            }
            if (vReminderCustom.hidden) {
                updateCustomDateTime(true, updateTime: true)
            }
        } else if (currentWWCPicker == "CustomDate") {
            reminderPicked = true
            reminderCustomDate = date
            updateCustomDateTime(true, updateTime: false)
        } else if (currentWWCPicker == "CustomTime") {
            reminderPicked = true
            reminderCustomTime = date
            updateCustomDateTime(false, updateTime: true)
        }
    }
    
    @IBAction func btnClearTime(sender: AnyObject) {
        withSpecificTime = false
//        pReminder.reloadAllComponents()
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
            } else {
                for tmpClass in classes {
                    if (tmpClass.name == txtTrimmed) {
                         SCLAlertView().showError("Class exists", subTitle: "", closeButtonTitle:"OK")
                        return
                    }
                }
                let newClass: Class = Class()
                newClass.name = txtTrimmed
                classes.append(newClass)
                self.pClass.reloadAllComponents()
                saveSystemClasses()
            }
        }
        alert.addButton("Cancel") { 
            //
        }
        alert.showCustom("Add a new Class", subTitle: "", color: cblue, icon: UIImage())
    }
    
    @IBAction func sReminder_ValueChanged(sender: AnyObject) {
        vReminderCustom.hidden = !sReminder.on
    }
    
    @IBAction func btnReminderCustomDate_Tapped(sender: AnyObject) {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionCurrentDate = nstoday()
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(false)
        selector.optionCurrentDate = dueDate
        presentViewController(selector, animated: true, completion: nil)
        currentWWCPicker = "ReminderCustomDate"
    }
    
    @IBAction func btnReminderCustomTime(sender: AnyObject) {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionCurrentDate = nstoday()
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        selector.optionCurrentDate = dueTime
        presentViewController(selector, animated: true, completion: nil)
        currentWWCPicker = "ReminderCustomTime"
    }
    
    @IBAction func sRepeat_ValueChanged(sender: AnyObject) {
        let alpha: CGFloat = (sRepeat.on ? 0 : 0.8)
        vRepeatBlocker.hidden = sRepeat.on
        UIView.animateWithDuration(0.5) {
            self.blurRepeat.alpha = alpha
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Finalize
    
    @IBAction func btnClose_Tapped(sender: AnyObject) {
        // check
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
            if (_EDIT) {
                var Ai: Int = 0
                for var i in 0 ... assignments.count - 1 {
                    if (assignments[i] == _editAssignment) {
                        Ai = i
                        break
                    }
                }
                assignments[Ai].desc = tfDesc.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                assignments[Ai].note = tvNotes.text
                assignments[Ai].assignmentType = cuiType
                assignments[Ai].fromClass = classes[cuiClass].name
                assignments[Ai].repeatType = cuiRepeat
                assignments[Ai].reminder = NSDate(year: reminderCustomDate.year, month: reminderCustomDate.month, day: reminderCustomDate.day, hour: reminderCustomTime.hour, minute: reminderCustomTime.minute)
                assignments[Ai].dueDate = dueDate
                assignments[Ai].opTime = withSpecificTime
                assignments[Ai].priority = cuiPriority
            } else {
                let newAssignment: Assignment = Assignment()
                newAssignment.desc = tfDesc.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                newAssignment.note = tvNotes.text
                newAssignment.assignmentType = cuiType
                newAssignment.fromClass = classes[cuiClass].name
                newAssignment.repeatType = cuiRepeat
                newAssignment.reminder = NSDate(year: reminderCustomDate.year, month: reminderCustomDate.month, day: reminderCustomDate.day, hour: reminderCustomTime.hour, minute: reminderCustomTime.minute)
                newAssignment.dueDate = dueDate
                newAssignment.opTime = withSpecificTime
                newAssignment.priority = cuiPriority
                assignments.append(newAssignment)
            }
            
            curFrmAssignmentList.convertTable(curFrmAssignmentList.showCompleted)
            curFrmAssignmentList.tableView.reloadData()
            saveSystemAssignments()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }


}
