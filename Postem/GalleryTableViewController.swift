//
//  GalleryTableViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/22/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit
import Parse

class GalleryTableViewController: UITableViewController {

    var imageFiles = [PFFile]()
    var users = [String: String]()
    var objetos = [String]()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        
        var queryUser = PFUser.query()
        queryUser?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let users = objects
            {
                self.users.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                
                for object in users
                {
                    if let user = object as? PFUser
                    {
                        self.users[user.objectId!] = user.username!
                    }
                }
            }
        })

        
        var query = PFQuery(className: "Post")
        
        query.whereKey("userId", equalTo: (PFUser.currentUser()?.objectId)!)
        
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects
            {
                for object in objects
                {
                    self.imageFiles.append(object["imageFile"] as! PFFile)
                    //self.dates.append(object.createdAt! as! NSDate)
                    self.objetos.append(self.users[object["userId"] as! String]!)

                    self.tableView.reloadData()
                }
            }
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objetos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GalleryCellTableViewCell
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!)
            {
                myCell.imageGallery.image = downloadedImage
            }
        }
        
        return myCell
        
    }
    


}
