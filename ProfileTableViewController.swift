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
    var imagesGallery = [PFFile]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato", size: 14)!]
        
        tableView.allowsSelection = true
        tableView.userInteractionEnabled = true
        
        var mygalleryQuery = PFQuery(className: "Post")
        mygalleryQuery.whereKey("userId", equalTo: (PFUser.currentUser()?.objectId)!)
        mygalleryQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects
            {
                self.imagesGallery.removeAll(keepCapacity: true)
                
                for object in objects
                {
                    self.imagesGallery.append(object["imageFile"] as! PFFile)
                    self.tableView.reloadData()
                }
            }
        }
        
        

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if indexPath.row == 6
        {
            //chosin, call alert para 3 opciones, 1, camera, upload photo, select it on postem
            print ("muestra una gallery")
            
            performSegueWithIdentifier("showGall", sender: self)
        }
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imagesGallery.count + 6
    }
    
    
    
//    //Title para la section
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        //return "Section \(section)"
//    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        if indexPath.section == 0
        {
            if let name = PFUser.currentUser()?["name"]
            {
                if indexPath.row == 0
                {
                    infoProfile.append(String(PFUser.currentUser()!.username!))
                    cell.textLabel!.text = "Username: " + infoProfile[indexPath.row]
                }
                if indexPath.row == 1
                {
                    infoProfile.append(String(PFUser.currentUser()!["name"]))
                    cell.textLabel!.text = "Name: " + infoProfile[indexPath.row]
                }
                if indexPath.row == 2
                {
                    infoProfile.append(String(PFUser.currentUser()!["password"]))
                    cell.textLabel!.text = "Password: ********" //+ infoProfile[indexPath.row]
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
                if indexPath.row == 6
                {
                    cell.textLabel?.textAlignment = .Center
                    cell.tintColor = UIColor.lightGrayColor()
                    cell.backgroundColor = UIColor.darkGrayColor()
                    cell.textLabel?.textColor = UIColor.whiteColor()
                    cell.textLabel?.font = UIFont.boldSystemFontOfSize(16.0)
                    cell.textLabel?.text = "MY GALLERY"
                    
//                    var img:UIImage = UIImage()
//                    
//                    print (indexPath.row - 6)
//                    
//                    imagesGallery[indexPath.row - 6].getDataInBackgroundWithBlock({ (data, error) -> Void in
//                        
//                        if let downloadedImage = UIImage(data: data!)
//                        {
//                            cell.imageView?.image = downloadedImage
//                        }
//                    })
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
