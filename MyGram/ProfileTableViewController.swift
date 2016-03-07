//
//  ProfileTableViewController.swift
//  MyGram
//
//  Created by Javier Gomez on 3/6/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController
{

   override func viewDidLoad()
   {
        super.viewDidLoad()
 
    }
 
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
 
    
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int
     {
        return 1
     }
     
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
     }
     
     
//     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let myCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! cell
//     
//        myCell.textLabel?.text = "Testing"
//     
//        return myCell
//        
//     }
//    

}
