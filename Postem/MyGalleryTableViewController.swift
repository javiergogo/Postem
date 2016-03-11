//
//  MyGalleryTableViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/10/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit

class MyGalleryTableViewController: UITableViewController {

    var numerodeimagenes:Int = 14
    var numerotempo: [Int] = [1, 3, 4, 5]
    var dividendo:Int = 0
    var modul:Int = 0
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    var imageSize:CGFloat = 0.0
    var borderSize:CGFloat = 0.0

   // CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.4f);
   // CGRectMake(0, self.view.frame.size.height * 0.4f, self.view.frame.size.width, self.view.frame.size.width * 0.6f);
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //carga todas las imagenes en un arreglo y las cuenta para indicar cuantas tablas seran
        imageSize = screenSize.width * 0.32
        borderSize = screenSize.width * 0.02
        self.tableView.rowHeight = (imageSize + borderSize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        dividendo = numerodeimagenes / 3
        modul = numerodeimagenes % 3
        
        if modul != 0
        {
            dividendo++
        }
        
        return dividendo
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

            for a in 0...2
            {
                var imageView: UIImageView = UIImageView()
                
                let tempPosition = borderSize * CGFloat(a)
                
                var image = UIImage(named: "profile.png")
                imageView.image = image
                imageView.frame = CGRectMake(imageSize * CGFloat(a) + tempPosition, 0, imageSize, imageSize ); // set new position exactly
                
                myCell.contentView.addSubview(imageView)
                
                print (imageView)
            }
        print ("sss")
        
        return myCell
    }
    


}
