//
//  EditProfileViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/8/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var username:String = ""
    var name:String = ""
    var phone:String = ""
    var email:String = ""
    var password:String = ""
    
    @IBOutlet var userTxt: UITextField!
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var phoneTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passTxt: UITextField!
    @IBOutlet var photoProfileBtn: UIImageView!
    
    //VARIABLE PARA HACER VALIDACION DE CAMBIO DE IMAGEN Y ESCRITURA DE MENSAJE
    var clikedUpload = false

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        userTxt.text = username
        nameTxt.text = name
        phoneTxt.text = phone
        emailTxt.text = email
        passTxt.text = ""
        

        //UINavigationBar.appearance().backgroundColor = UIColor.blackColor()
//        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//
//        UINavigationBar.appearance().titleTextAttributes =  [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        
//        UINavigationBar.appearance().barTintColor = UIColor(red: 55.0/255.0, green: 143.0/255.0, blue: 243.0/255.0, alpha: 1)

        //UITabBar.appearance().backgroundColor = UIColor.yellowColor();
        
        
        if let photoProfileQuery = PFUser.currentUser()?.objectId
        {
            if let photo = PFUser.currentUser()?["photoProfile"]
            {
                photo.getDataInBackgroundWithBlock { (data, error) -> Void in
                    if let downloadedImage = UIImage(data: data!)
                    {
                        self.photoProfileBtn.image = self.maskRoundedImage(downloadedImage, radius: 20.0)
                    }
                }
            }
            else
            {
                //no tiene imagen, keeps the default one
            }
        }
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func photoProfileAction(sender: AnyObject)
    {
        
        cameraGallery("Chose", message: "Please chose your best option")
        
    }
   
    var saved = false
    
    @IBAction func saveButton(sender: AnyObject)
    {
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if let user = PFUser.currentUser()
        {
            let namePhoto = "imageprofile_" + String(PFUser.currentUser()!["username.jpg"])
            
            let imageDate = UIImageJPEGRepresentation(photoProfileBtn.image!, 9.9)
            
            let imageFile = PFFile(name: namePhoto, data: imageDate!)
            
            user["photoProfile"] = imageFile
            
            user["username"] = userTxt.text
            user["name"] = nameTxt.text
            user["phone"] = phoneTxt.text
            user["email"] = emailTxt.text
            if passTxt.text != ""
            {
                user["password"] = passTxt.text
            }
            
            user.saveInBackgroundWithBlock
                { (success, error) -> Void in
            
                    self.activityIndicator.stopAnimating()
            
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
                    if error == nil
                    {
                        self.displayAlert("Updated", message: "Your information has been updated")
                        self.saved = true
                        
                    }
                    else
                    {
                        self.displayAlert("Couldn't Save", message: "It was not possible to save your information, try again")
                    }
            }
        }
    }
    
    func performSegue(identifier:String){
        self.performSegueWithIdentifier(identifier, sender: self)
    }

    
    
    
    func displayAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if self.saved == true
            {
                self.performSegue("showProfileUpdated")
                
            }
            //self.dismissViewControllerAnimated(true, completion: nil)
        
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
       
    }
    
    var activityIndicator = UIActivityIndicatorView()
    


    
    
    func cameraGallery(title:String, message:String)
    {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Camera", style: .Default) { (action:UIAlertAction!) in
            self.pictureWithCamera()
            
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .Default) { (action:UIAlertAction!) in
            self.pictureWithLibrary()
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(libraryAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func pictureWithCamera()
    {
        
        //CONTROL PARA SELECIONAR IMAGEN LO ASIGNAMOS A IMAGE VARIABLE
        var image = UIImagePickerController()
        //LE DAMOS CONTROL SOBRE ELLA MISMA Y EL VIEWCONTROLLER
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
        clikedUpload = true
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
        
        clikedUpload = true
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //primero CAMBIA TAMANO LUEGO LLAMA A CIRCULAR LAS PUNTAS
        
        let resizedImage = resizeImage(image, newWidth: 100)
        
        let squaredImage = cropToSquare(image: resizedImage)
        
        photoProfileBtn.image = squaredImage
        print (photoProfileBtn.image)
        
        photoProfileBtn.image = maskRoundedImage(squaredImage, radius: 15.0)
        //photoProfileBtn = roundImage(photoProfileBtn)
        //print (photoProfileBtn.image)



        
    }
    
    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage
    {
        var imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
    
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor =  UIColor.darkGrayColor().CGColor//(red: 255.0/255.0, green: 142.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }

    
    func roundImage (rounded: UIImageView) -> UIImageView
    {
        rounded.layer.borderWidth = 1
        rounded.layer.masksToBounds = true
        rounded.layer.borderColor = UIColor(red: 255.0/255.0, green: 142.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor
        rounded.layer.cornerRadius = rounded.frame.size.height / 2
        rounded.clipsToBounds = true
        
        return rounded
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
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage
    {
        //RESIZE
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        cropToSquare(image: newImage)
        
        //print (newImage)

        return newImage
        
    }

    
    
    
}
