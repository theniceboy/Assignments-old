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
    
    var tableAssignments: [[Assignment]] = [], tableDueDates: [Date] = [], tmpAssignments: [Assignment] = []
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curFrmAssignmentList = self
        
        let nsAssignments = NSUserDefaults.standardUserDefaults().objectForKey("assignments")
        if (nsAssignments != nil) {
            assignments = NSKeyedUnarchiver.unarchiveObjectWithData(nsAssignments as! NSData) as! [Assignment]
        }
        
        convertTable()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func convertTable () {
        tableAssignments = []
        tableDueDates = []
        var tmpTableRow: [Assignment] = []
        if (assignments.count == 0) {
            return
        }
        tmpAssignments = assignments
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
                if (tmpAssignments[i].dueDate != tmpAssignments[i + 1].dueDate) {
                    tableAssignments.append(tmpTableRow)
                    tableDueDates.append(tmpAssignments[i].dueDate)
                    tmpTableRow = []
                }
            }
            i = tmpAssignments.count - 1
            if (tmpTableRow.count == 0) {
                tableDueDates.append(tmpAssignments[i].dueDate)
            }
            tmpTableRow.append(tmpAssignments[i])
            tableAssignments.append(tmpTableRow)
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
        return dateToString(tableDueDates[section])
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
