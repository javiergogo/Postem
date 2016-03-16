//
//  MyCollectionViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/12/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "MyCell"


struct imagenEscogida
{
    static var miImagen = UIImage()
}


class MyCollectionViewController: UICollectionViewController  {

    var imageGallery = [PFFile]()
    
    var imageChosen : UIImage = UIImage()
   
    var selected = [Bool]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        
        let user = PFUser.currentUser()?.objectId
        
        var galleryQuery = PFQuery(className: "Post")
        galleryQuery.whereKey("userId", equalTo: user!)
        
        galleryQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil
            {
                if let objects = objects
                {
                    for object in objects
                    {
                        self.imageGallery.append(object["imageFile"] as! PFFile)
                        
                    }
                    self.collectionView?.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
    
        imageGallery[indexPath.row].getDataInBackgroundWithBlock
        {   (data, error) in

            if let cacheImage = UIImage(data: data!)
            {
                cell.imageView.image = cacheImage
                
                self.imageChosen = cacheImage
            }
        }
            
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 0
        
        print (indexPath.row)
        
        selected.append(false)
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let size = UIScreen.mainScreen().bounds.size
        let sizeCelda = (size.width - 2) / 3
        
        return CGSize(width: sizeCelda, height: sizeCelda + 1)
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
        
        print (selected[indexPath.row])
        
        if selected[indexPath.row] == false
        {
            selectedCell!.layer.borderWidth = 3.0
            selectedCell!.layer.borderColor = UIColor.blueColor().CGColor

            imageGallery[indexPath.row].getDataInBackgroundWithBlock { (data, error) in
                if let cacheImage = UIImage(data: data!)
                {
                    self.imageChosen = cacheImage
                    self.iralOtro()
                }
            }
            
        selected[indexPath.row] = true
        }
        else if selected[indexPath.row] == true
        {
            selectedCell!.layer.borderWidth = 0.0
            selected[indexPath.row] = false
        }
        

        
    }

    var temp = ""
    
    func iralOtro()
    {
        performSegueWithIdentifier("showone", sender: self)
        
        imagenEscogida.miImagen = imageChosen
        
    }
        //let image = imageChosen as? SharingTableViewController
    
    

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    }
    */

}
