//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Javier Gomez on 2/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //FUNCION PARA MOSTRAR SPINNER
    func displayAlert(title: String, message: String)
    {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
   
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var message: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    //VARIABLE PARA HACER VALIDACION DE CAMBIO DE IMAGEN Y ESCRITURA DE MENSAJE
    var chosingImage = false

    
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
    
    
    @IBAction func choseImage(sender: AnyObject)
    {
        //Obtenes el valor que el usuario selecciono si quiere camara o libreria
       cameraGallery("Chose", message: "Please chose your best option")
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
        
        chosingImage = true
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
        
        chosingImage = true

        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = resizeImage(image, newWidth: 640)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        if message.text != "" && chosingImage != false
        {
            chosingImage = true
            
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()

            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Post")
            
            post["message"] = message.text
            
            post["userId"] = PFUser.currentUser()!.objectId!
            
            let imageDate = UIImageJPEGRepresentation(imageToPost.image!, 9.9)
            
            let imageFile = PFFile(name: "image.jpg", data: imageDate!)
            
            post["imageFile"] = imageFile
            
            post.saveInBackgroundWithBlock { (success, error) -> Void in

                self.activityIndicator.stopAnimating()
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil
                {
                    self.displayAlert("Image Posted", message: "Ya chingaste tu imagen se guardo")
                    
                    self.imageToPost.image = UIImage(named: "camera.jpg")
                    
                    self.message.text = ""
                }
                else
                {
                    self.displayAlert("Couldn't Post", message: "Ni pedo, try later")
                }
                
            }
        }
        else
        {
            self.displayAlert("Fill it up.!", message: "Please try not to be so lazy, and fill it up, all !")
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
