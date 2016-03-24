//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Javier Gomez on 2/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import AVFoundation


class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    
    //FUNCION PARA MOSTRAR SPINNER
    func displayAlert(title: String, message: String)
    {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //VARIALBES PARA CAMARA
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    @IBOutlet var previewView: UIView!

    @IBOutlet var libraryButton: UIButton!
   
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var message: UITextField!
    
    @IBOutlet var postButton: UIButton!
    
    @IBOutlet var cameraButton: UIButton!
    
    @IBOutlet var shooterButton: UIButton!
    
    @IBOutlet var cancelButton: UIButton!

    
    
    var activityIndicator = UIActivityIndicatorView()
    
    //VARIABLE PARA HACER VALIDACION DE CAMBIO DE IMAGEN Y ESCRITURA DE MENSAJE
    var chosingImage = false

    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = previewView.bounds

    }
    
    @IBAction func cameraButton(sender: AnyObject) {
        //self.pictureWithCamera()
        
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.previewView.hidden = true
                    
                    self.imageToPost.image = self.cropToSquare(image: image)
                }
            })
        }
        chosingImage = true
        
        cameraButton.enabled = false
        libraryButton.enabled = true
        postButton.enabled = true
        message.enabled = true
        
        previewView.hidden = true
        imageToPost.hidden = false
        
        shooterButton.enabled = false
        shooterButton.hidden = true
        
        cancelButton.enabled = true
        cancelButton.hidden = false
        
        
    }

    @IBAction func cancelAction(sender: AnyObject)
    {
        cameraButton.enabled = false
        libraryButton.enabled = true
        postButton.enabled = false
        message.enabled = false
        
        previewView.hidden = false
        
        shooterButton.enabled = true
        shooterButton.hidden = false
        
        cancelButton.enabled = false
        cancelButton.hidden = true
        
    }
    
    
    func cameraGallery(title:String, message:String)
    {

        let alertController = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.ActionSheet)

        let cancelAction = UIAlertAction(title: "Camera", style: .Default) { (action:UIAlertAction!) in

        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .Default) { (action:UIAlertAction!) in

        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(libraryAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
    
    
    
    
    @IBAction func choseImage(sender: AnyObject)
    {
        //Obtenes el valor que el usuario selecciono si quiere camara o libreria
       //cameraGallery("Chose", message: "Please chose your best option")
        self.pictureWithLibrary()
    }
    
    
    func pictureWithCamera()
    {
        
        //CONTROL PARA SELECIONAR IMAGEN LO ASIGNAMOS A IMAGE VARIABLE
        var image = UIImagePickerController()
        //LE DAMOS CONTROL SOBRE ELLA MISMA Y EL VIEWCONTROLLER
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        
        //starting
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
        
        //imageToPost.image = cropToSquare(image: image)
        
        let imagen = resizeImage(image, newWidth: 800)
        
        imageToPost.image = cropToSquare(image: imagen)
        
        self.postButton.enabled = true
        self.message.enabled = true
        
        previewView.hidden = true
        imageToPost.hidden = false
        
        shooterButton.hidden = true
        shooterButton.enabled = false
        
        cancelButton.hidden = false
        cancelButton.enabled = true
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
                    self.displayAlert("Image Posted", message: "Your image has been saved")
                    
                    //self.imageToPost.image = UIImage(named: "camera.jpg")
                    
                    self.cameraButton.enabled = false
                    self.libraryButton.enabled = true
                    self.postButton.enabled = false
                    self.message.enabled = false
                    self.message.text = ""
                    
                    self.previewView.hidden = false
                    self.imageToPost.hidden = true
                    
                    self.shooterButton.hidden = false
                    self.shooterButton.enabled = true
                    
                    self.cancelButton.hidden = true
                    self.cancelButton.enabled = false
                }
                else
                {
                    self.displayAlert("Couldn't Post", message: "Please, try later!")
                }
            }
        }
        else
        {
            self.displayAlert("Necessary Fields", message: "All the fields in the form are requiered, thank you.")
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        if let navcontroller = self.navigationController
        {
            navcontroller.navigationBarHidden = true
            self.navigationController?.toolbarHidden = true

            //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "ClickerScript-Regular", size: 20)!]

            
            self.tabBarController?.tabBar.hidden = true
        }
        
        self.message.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true;
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
