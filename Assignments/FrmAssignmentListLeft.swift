//
//  FrmAssignmentListLeft.swift
//  Assignments
//
//  Created by David Chen on 25/09/2016.
//  Copyright © 2016 David Chen. All rights reserved.
//

import UIKit

class FrmAssignmentListLeft: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let nsClasses = NSUserDefaults.standardUserDefaults().objectForKey("classes")
        if (nsClasses != nil) {
            classes = NSKeyedUnarchiver.unarchiveObjectWithData(nsClasses as! NSData) as! [Class]
        }
        if (classes.count == 0) {
            let generalClass: Class = Class()
            generalClass.name = "General"
            classes.append(generalClass)
            saveSystemClasses()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
