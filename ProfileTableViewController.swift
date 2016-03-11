//
//  ProfileTableViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/7/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit
import Parse

class ProfileTableViewController: UITableViewController {
    

    var infoProfile = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)


        if let name = PFUser.currentUser()?["name"]
        {
            if indexPath.section == 0
            {
                if indexPath.row == 0
                {
                    infoProfile.append(String(PFUser.currentUser()!.username!))
                    cell.textLabel!.text = infoProfile[indexPath.row]
                }
                if indexPath.row == 1
                {
                    infoProfile.append(String(PFUser.currentUser()!["name"]))
                    cell.textLabel!.text = "Name: " + infoProfile[indexPath.row]
                }
                if indexPath.row == 2
                {
                    infoProfile.append(String(PFUser.currentUser()!["password"]))
                    cell.textLabel!.text = "Pass: " + infoProfile[indexPath.row]
                }
                if indexPath.row == 3
                {
                    infoProfile.append(String(PFUser.currentUser()!["phone"]))
                    cell.textLabel!.text = "Phone: " + infoProfile[indexPath.row]
                }
                if indexPath.row == 4
                {
                    infoProfile.append(String(PFUser.currentUser()!["email"]))
                    cell.textLabel!.text = "E-mail: " + infoProfile[indexPath.row]
                }

            }
           
            
            if indexPath.section == 1
            {
                if indexPath.row == 0
                {
                
                var foundObj = ""
                var count = 0
                
                var query = PFQuery(className:"Post")
                
                query.whereKey("userId", equalTo:(PFUser.currentUser()?.objectId)!)
                query.findObjectsInBackgroundWithBlock
                    {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil
                    {
                        // The find succeeded.
                        
                        if let objects = objects
                        {
                            for object in objects
                            {
                                //print(object["message"])
                                foundObj = object["message"] as! String
                                count++
                                
                                //when is the last object found, get la imagen y ponla en la celda
                                if count == objects.count
                                {
                                    
                                    let userImageFile = object["imageFile"] as! PFFile
                                    userImageFile.getDataInBackgroundWithBlock
                                        {
                                        (imageData: NSData?, error: NSError?) -> Void in
                                        if error == nil
                                        {
                                            if let imageData = imageData
                                            {
                                                let image = UIImage(data:imageData)
                                                cell.imageView?.image = image
                                            }
                                        }
                                            else
                                            {
                                                print (error)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    else
                    {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    }
                }
            }
        
        }
        
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //PREGUNTAMOS SI EL IDENTIFICADOR ES IGUAL A LOGOUTRIDER ENTONCES HAZ ESO (LOGOUT)
        
        if segue.identifier == "LoginfromOut"
        {
            if let nombre = PFUser.currentUser()
            {
                PFUser.logOut()
                var currentUser = PFUser.currentUser()
                
            }
            else
            { print ("no recibiendo nada") }
        }
        
        if segue.identifier == "showEditProfile"
        {
            
            if let information = segue.destinationViewController as? EditProfileViewController
            {
                                information.username = infoProfile[0]
                                information.name = infoProfile[1]
                                information.password = infoProfile[2]
                                information.phone = infoProfile[3]
                                information.email = infoProfile[4]

                
            }
            
            
           
        }
        
    }

    
    
    
    
}
