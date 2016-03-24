//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Javier Gomez on 1/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    //ARREGLOS PARA ALMACENAR LOS NOMBRES Y SUS ID
    var usernames = [""]
    var userids = [""]
    //DICTIONARIO PARA ALMACENAR EL ID DE EL SEGUIDOR Y ID DE QUIEN SIGUIENDO
    var isFollowing = ["":false]
    
    var imageFiles = [PFFile]()
    
    //variable global para refrescar o actualizar cuando el usuario pucha para abajo
    var refresher: UIRefreshControl!
    
    
    
    
    func refresh()
    {
        var query = PFUser.query()
        //SOLICITAR UN CONSULTA PARA BUSCAR UN OBJECTO EL CUAL ES DE TIPO PFUSER
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            //SI PUDO ALMACENAR EN users SIGNIFICA QUE objects TIENE ALGO
            if let users = objects
            {
                //LIMPIAMOS ARREGLOS Y DICCIONARIO
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                
                //RECORRE TODOS LOS users EL CUAL CONTIENE TODOS LOS OBJECTS
                for object in users
                {
                    //SI PUEDE ALMACENAR, SIGNIFICA ENCONTRO USUARIO
                    if let user = object as? PFUser
                    {
                        //SI EL ID DEL USUARIO QUE ENCONTRO ES DIFERENTE DEL ID DEL USUARIO ACTIVO
                        if user.objectId! != PFUser.currentUser()?.objectId {
                            
                            //AGREGA EL NOMBRE Y EL ID A SUS RESPECTIVOS ARREGLOS
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            //self.imageFiles.append(user["photoProfile"])
                            
                            
                            //HAREMOS UNA CONSULTA EN LA CLASE LLAMADA FOLLOWERS, ES OTRA TABLA, DIFERENTE A LA DE USUARIOS EN PARSE
                            var query = PFQuery(className: "followers")
                            
                            //HACER UNA QUERY DONDE SE PREGUNTA SI EL CAMPO FOLLOWER ES IGUAL AL ID DEL USUARIO ACTIVO
                            //ABRIR EL CAMPO DONDE LA INFORMACION EN BASE DE DATOS ES IGUAL A LA QUE TENEMOS TEMPORALMENTE EN LA APP
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            //AHORA BUSCAR ESA INFORMACION
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                
                                //SI ASIGNA SIGNIFICA QUE ENCONTRO ALGO
                                if let objects = objects
                                {
                                    if objects.count > 0 {
                                        //SI ENCONTRO SE LE DA EL VALOR VERDADERO AL DICCIONARIO EN LA POSICION DEL ID DEL USUARIO
                                        self.isFollowing[user.objectId!] = true
                                        
                                    } else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                
                                if self.isFollowing.count == self.usernames.count {
                                    
                                    self.tableView.reloadData()
                                    
                                    self.refresher.endRefreshing()

                                }
                            })
                        }
                    }
                }
            }
        })

    }
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        refresher = UIRefreshControl()
            
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            
        //we will run when the value has changes, soo when some one pull down
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
            
        self.tableView.addSubview(refresher)
        
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato", size: 14)!]
            
        refresh()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return usernames.count
    }
    
    
    //FUNCION PARA QUE ASIGNAR LOS USUARIOS QUE SE ESTAN SIGUIENDO, UN CHECKMARK
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        //EL TEXTO DE LOS ARREGLOS USERNAMS (VARIABLES GLOBALES) EN LA POSICION INDEXPATH (ES LA QUE EL USUARIO SELECCIONO) SON ASIGNADOS A CADA UNA DE LAS CELDAS
        cell.textLabel?.text = usernames[indexPath.row]
        
        //EL ID DEL USUARIO QUE SE SELECCIONO SE ASIGNA A VARIABLE FOLLOWEDOBJECTID
        let followedObjectId = userids[indexPath.row]
        
        //SI ESTA ACTIVA ESTA VARIABLE SIGNIFICA QUE ANTERIORIMENTE SE CAMBIO CUANDO SE COMENZO A SEGUIR AL USUARIO
        if isFollowing[followedObjectId] == true
        {
            //PONE UN CHECK MARK EN EL USUARIO SELECCIONADO
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let followedObjectId = userids[indexPath.row]
        
        if isFollowing[followedObjectId] == false {
            
            isFollowing[followedObjectId] = true
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            var following = PFObject(className: "followers")
            following["following"] = userids[indexPath.row]
            following["follower"] = PFUser.currentUser()?.objectId
            
            following.saveInBackground()
            
        } else {
            
            isFollowing[followedObjectId] = false
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className: "followers")
            
            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            query.whereKey("following", equalTo: userids[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                        
                    }
                }
                
                
            })
            
            
            
        }
        
    }
    
    
    @IBAction func logout(sender: AnyObject)
    {
        if PFUser.currentUser() != nil
        {
            PFUser.logOut()
        }
    }
}

