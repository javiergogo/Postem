//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Javier Gomez on 2/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController
{

    var messages = [String]()
    var usernames = [String]()
    var dates = [NSDate]()
    var imageFiles = [PFFile]()
    var users = [String: String]()
    var usersId = [String]()
    var imagePro = [String: PFFile]()
    
    
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
        //save things
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dont", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Click", style: UIBarButtonItemStyle.Done, target: self, action: "done")
        
        //self.title = "Postem"
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "ClickerScript-Regular", size: 20)!]

        

        
        
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
                self.dates.removeAll(keepCapacity: true)
                self.usersId.removeAll(keepCapacity: true)
                
                //RECORRE TODOS LOS users EL CUAL CONTIENE TODOS LOS OBJECTS
                for object in users
                {
                    if let user = object as? PFUser
                    {
                        self.users[user.objectId!] = user.username!
                        self.imagePro.updateValue(user["photoProfile"] as! PFFile, forKey: user.objectId!)
                    }
                }
            }
        })
        
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
                                self.dates.append(object.createdAt! as! NSDate)
                                
                                self.usernames.append(self.users[object["userId"] as! String]!)
                                
                                self.usersId.append(object["userId"] as! String)
                                
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        //send to transform and make round corners
        myCell.profileImage!.layer.borderWidth = 1
        myCell.profileImage!.layer.masksToBounds = false
        myCell.profileImage!.layer.borderColor = UIColor(red: 255.0/255.0, green: 142.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor
        // .blackColor().CGColor
        myCell.profileImage.layer.cornerRadius = myCell.profileImage.frame.height / 2
        myCell.profileImage!.clipsToBounds = true
        
        //tomar el user id actual y buscar en los perfiles luego sacarlo para mostrarlo en la celda
        
        //print (imagePro)
        

        var query = PFUser.query()
        

        
        var img : UIImage = UIImage()
        
        imagePro[usersId[indexPath.row]]?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            
            myCell.profileImage.image = UIImage(data: data!)!
        })
        
        
        
        myCell.username.text = usernames[indexPath.row]
        
        myCell.message.text = messages[indexPath.row]
        
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        //formatter.timeStyle = .MediumStyle
        
        let dateString = formatter.stringFromDate(dates[indexPath.row])
        
        myCell.dates.text = String(dateString)

 
        return myCell
    }
    

}
