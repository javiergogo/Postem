//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Javier Gomez on 2/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var users = [String: String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var query = PFUser.query()
        //SOLICITAR UN CONSULTA PARA BUSCAR UN OBJECTO EL CUAL ES DE TIPO PFUSER
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
        //SI PUDO ALMACENAR EN users SIGNIFICA QUE objects TIENE ALGO
        if let users = objects
        {
            //LIMPIAMOS ARREGLOS Y DICCIONARIO
            self.messages.removeAll(keepCapacity: true)
            self.users.removeAll(keepCapacity: true)
            self.imageFiles.removeAll(keepCapacity: true)
            self.usernames.removeAll(keepCapacity: true)
            
            //RECORRE TODOS LOS users EL CUAL CONTIENE TODOS LOS OBJECTS
            for object in users
            {
                if let user = object as? PFUser
                {
                    self.users[user.objectId!] = user.username!
                }
            }
        }


        var getFollowedUserQuery = PFQuery(className: "followers")
    
        getFollowedUserQuery.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
        getFollowedUserQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
        
        if let objects = objects
        {
            for object in objects
            {
                var followedUser = object["following"] as! String
                
                
                var query = PFQuery(className: "Post")
                
                query.whereKey("userId", equalTo: followedUser)
                
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    
                    if let objects = objects
                    {
                        for object in objects
                        {
                            self.messages.append(object["message"] as! String)
                            self.imageFiles.append(object["imageFile"] as! PFFile)
                            self.usernames.append(self.users[object["userId"] as! String]!)
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                })
            }
        }
        }
        })
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
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    //ASIGNAMOS UNA VARIABLE LLAMADA MYCEL DE TIPO CELL, EL TIPO CELL ES OBTENIDO DE LA CLASE (OBJECTO) QUE SE CREO
    //AHORA MYCELL, TIENE TODAS LAS PROPIEDADES Y TIENE HERADOS LOS VINCULOS QUE SE HICIERON ALLA
    //ES POR ESO QUE AQUI DETECTA USERNAME Y MESSAGE
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell

        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!)
            {
                myCell.postedImage.image = downloadedImage
            }
        }
        
        
        
        myCell.username.text = usernames[indexPath.row]
        
        myCell.message.text = messages[indexPath.row]
        
        return myCell
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

    @IBAction func logout(sender: AnyObject) {
        if PFUser.currentUser() != nil
        {
            PFUser.logOut()
        }
    }
}
