//
//  FrmAssignmentList.swift
//  Assignments
//
//  Created by David Chen on 9/4/16.
//  Copyright © 2016 David Chen. All rights reserved.
//

import UIKit

class FrmAssignmentList: UITableViewController {

    // MARK: - Variables
    
    var tableAssignments: [[Assignment]] = [], tableDueDates: [NSDate] = [], tmpAssignments: [Assignment] = []
    var showCompleted: Bool = false
    var selectedAssignment: Assignment!
    var goEdit: Bool = false
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curFrmAssignmentList = self
        
        let nsAssignments = NSUserDefaults.standardUserDefaults().objectForKey("assignments")
        if (nsAssignments != nil) {
            assignments = NSKeyedUnarchiver.unarchiveObjectWithData(nsAssignments as! NSData) as! [Assignment]
        }
        
        convertTable(false)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func convertTable (showCompletd: Bool) {
        //print("________All Assignments:", assignments[0].dueDate)
        tableAssignments = []
        tableDueDates = []
        var tmpTableRow: [Assignment] = []
        if (assignments.count == 0) {
            return
        }
        if (showCompletd) {
            tmpAssignments = assignments
        } else {
            tmpAssignments = []
            for var i in 0 ... assignments.count - 1 {
                if (!assignments[i].completed) {
                    tmpAssignments.append(assignments[i])
                }
            }
        }
        if (tmpAssignments.count == 0) {
            return
        }
        if (tmpAssignments.count > 1) {
            var i: Int, j: Int
            for i in 0 ... tmpAssignments.count - 2 {
                for j in i + 1 ... tmpAssignments.count - 1 {
                    if (tmpAssignments[i].dueDate > tmpAssignments[j].dueDate) {
                        swap(&tmpAssignments[i], &tmpAssignments[j])
                    }
                }
            }
            for i in 0 ... tmpAssignments.count - 2 {
                tmpTableRow.append(tmpAssignments[i])
                if (!nsdateEqual(tmpAssignments[i].dueDate, d2: tmpAssignments[i + 1].dueDate)) {
                    tableAssignments.append(tmpTableRow)
                    tableDueDates.append(tmpAssignments[i].dueDate)
                    tmpTableRow = []
                }
            }
            i = tmpAssignments.count - 1
            tmpTableRow.append(tmpAssignments[i])
            tableAssignments.append(tmpTableRow)
            tableDueDates.append(tmpAssignments[i].dueDate)
            /*
            a:103 b:104
            tmpTableRow [b]
            tableDueDates [103]
            tableAssignments [[a]]
            */
        } else {
            tmpTableRow.append(tmpAssignments[0])
            tableDueDates.append(tmpAssignments[0].dueDate)
            tableAssignments.append(tmpTableRow)
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableAssignments.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableAssignments[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AssignmentID", forIndexPath: indexPath) as! FrmAssignmentList_Cell
        cell.assignment = tableAssignments[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print(tableDueDates[section].year, tableDueDates[section].month, tableDueDates[section].day)
        return dateToString(Date(year: tableDueDates[section].year, month: tableDueDates[section].month, day: tableDueDates[section].day))
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedAssignment = tableAssignments[indexPath.section][indexPath.row]
        goEdit = true
        performSegueWithIdentifier("sFrmNewAssignment", sender: tableView)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            // Delete the row from the data source
            let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            alert.addButton("Delete") {
                for var i in 0 ... assignments.count - 1 {
                    if (assignments[i] == self.tableAssignments[indexPath.section][indexPath.row]) {
                        assignments.removeAtIndex(i)
                        break
                    }
                }
                self.convertTable(false)
                saveSystemAssignments()
                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.reloadData()
            }
            alert.addButton("Cancel") {
                //
            }
            alert.showWarning("Are you sure you want to delete?", subTitle: "You cannot undo this action")
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // IBActions
    
    @IBAction func TMPShowCompletedTapped(sender: AnyObject) {
        showCompleted = !showCompleted
        convertTable(showCompleted)
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func btnAdd_Tapped(sender: AnyObject) {
        goEdit = false
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (goEdit) {
            let vc: FrmNewAssignment = segue.destinationViewController as! FrmNewAssignment
            vc._EDIT = true
            vc._editAssignment = selectedAssignment
            goEdit = false
        }
    }
    

}
