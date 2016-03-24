//
//  SharingTableViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/9/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit
import Parse
import Social
import AVFoundation


class SharingTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate {

    @IBOutlet var imagen: UIImageView!
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato", size: 14)!]
        
        imagen.frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.width)
        
        loadMyImage(ima)
        
    }
    
    var ima = UIImage()

    func loadMyImage(img: UIImage)
    {
        self.imagen.image = (data: img)
        
    }
    
    //MUESTRA ALERTA RECIBIENDO EL TITULO Y MENSAJE
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        })))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
        
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        //FILLING THE CELLS WITH MI INFORMACION
        if indexPath.row == 0
        {
            myCell.textLabel?.textAlignment = .Right
            myCell.tintColor = UIColor.lightGrayColor()
            myCell.backgroundColor = UIColor.darkGrayColor()
            myCell.textLabel?.textColor = UIColor.whiteColor()
            myCell.textLabel?.font = UIFont.boldSystemFontOfSize(14.0)
            myCell.textLabel?.text = "C H O S E"
        }
        if indexPath.row == 1
        {
            myCell.accessoryType = .DisclosureIndicator
            myCell.tintColor = UIColor.lightGrayColor()
            myCell.textLabel?.text = "Facebook"
        }
        if indexPath.row == 2
        {
            myCell.accessoryType = .DisclosureIndicator
            myCell.tintColor = UIColor.lightGrayColor()
            myCell.textLabel?.text = "Instagram"
        }
        if indexPath.row == 3
        {
            myCell.accessoryType = .DisclosureIndicator
            myCell.tintColor = UIColor.lightGrayColor()
            myCell.textLabel?.text = "Twitter"
        }
        
        return myCell
    }
    
    /* for getting the small button with detail in the right side, like info button
        cell.accessoryType = .DetailDisclosureButton
        //funcion para eso
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //doSomethingWithItem(indexPath.row)
    }
    */
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if indexPath.row == 0
        {
            //chosin, call alert para 3 opciones, 1, camera, upload photo, select it on postem
            choosingSource("", message: "")
        }
        //MIENTRAS EL USUARIO NO HA SELECCIONADO IMAGEN ESTO NO SE CUMPLIRA
        if imagen.image != nil
        {
            if  indexPath.row == 1
            {
                //"Facebook"
                callFacebook()
            }
            if indexPath.row == 2
            {
                //"Instagram"
                callInstagram()
            }
            if indexPath.row == 3
            {
                //"Twitter"
                callTwitter()
            }
        }
        else
        {
            displayAlert("Chose", message: "You have to chose at least one image")
        }
    }
    
    //SELECCIONAR QUE TIPO DE SOURCE SERA, ENVIANDO UNA ActionSheet
    func choosingSource(title:String, message:String)
    {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: .Default)
        {
            (action:UIAlertAction!) in
            self.pictureWithCamera()
        }
        
        let uploadAction = UIAlertAction(title: "Upload a Photo", style: .Default)
        {
            (action:UIAlertAction!) in
            self.pictureWithLibrary()
        }
        
        let selectAction = UIAlertAction(title: "Select Photo on Postem", style: .Default)
        {
            (action:UIAlertAction!) in
            self.pictureWithPostem()
            //me tiene que mandar a una tabla desplegando todas mis fotos para seleccionar
            //llamar picturewithpostem
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in })
        
        //stix general
        alertController.addAction(cameraAction)
        alertController.addAction(uploadAction)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //FUNCION PARA SELECCIONAR FOTO DESDE LA CAMARA
    func pictureWithCamera()
    {
        
        //CONTROL PARA SELECIONAR IMAGEN LO ASIGNAMOS A IMAGE VARIABLE
        var image = UIImagePickerController()
        //LE DAMOS CONTROL SOBRE ELLA MISMA Y EL VIEWCONTROLLER
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func pictureWithLibrary()
    {
        
        //CONTROL PARA SELECIONAR IMAGEN LO ASIGNAMOS A IMAGE VARIABLE
        var image = UIImagePickerController()
        //LE DAMOS CONTROL SOBRE ELLA MISMA Y EL VIEWCONTROLLER
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func pictureWithPostem()
    {
        performSegueWithIdentifier("showMyGallery", sender: self)
        
    }

    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //LLAMAR A LA FUNCION DE CUADRADO Y MANDARLE LA IMAGEN
        imagen.image = cropToSquare(image: image)
        //imagen.image = image
        print (imagen.image)
        print (image)
    }
    
    func cropToSquare(image originalImage: UIImage) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage!)
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        
        return image
    }
    
    
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func callFacebook()
    {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc.setInitialText("#postem")
        vc.addImage(imagen.image!)
        //vc.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func callInstagram()
    {
        let instagramURL = NSURL(string: "instagram://app")
        
        if (UIApplication.sharedApplication().canOpenURL(instagramURL!))
        {
            let imageData = UIImageJPEGRepresentation(imagen.image!, 100)
            let captionString = "#postem"
            
            let writePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("instagram.igo")
            if imageData?.writeToFile(writePath, atomically: true) == false
            {
                return
            }
            else
            {
                let fileURL = NSURL(fileURLWithPath: writePath)
                
                self.documentController = UIDocumentInteractionController(URL: fileURL)
                self.documentController.delegate = self
                self.documentController.UTI = "com.instagram.exlusivegram"
                self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption")
                self.documentController.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true)
            }
        }
        else
        {
            print(" Instagram isn't installed ")
        }

    }
    
    func callTwitter()
    {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.setInitialText("#postem")
        vc.addImage(imagen.image!)
        //vc.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
        presentViewController(vc, animated: true, completion: nil)
    }


    var documentController: UIDocumentInteractionController!
    
    
    
}
