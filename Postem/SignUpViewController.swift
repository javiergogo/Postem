//
//  SignUpViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/6/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet var nameText: UITextField!
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var phoneText: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //======= DISPLAY ALERT==========//
    //funcion que llamaremos CADA QUE QUERAMOS UTILIZAR UNA ALERTA, SOLO ENVIAMOS UN TITULO Y UN MENSAJE, QUE ESTA FUNCION ESTA ESPERANDO
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    @IBAction func signupButton(sender: AnyObject)
    {
        if nameText.text == nil || usernameText.text == "" || passwordText.text == "" || emailText.text == ""
        {
            displayAlert("Error in form", message: "Please enter all the information")
        }
        else
        {
            
            var user = PFUser()
            user["name"] = nameText.text
            user.username = usernameText.text
            user.password = passwordText.text
            user.email = emailText.text
            user["phone"] = phoneText.text
            
            let ima = UIImage(named: "profile.png")
            let imagePro = UIImagePNGRepresentation(ima!)
            
            //let imageProfile = UIImageJPEGRepresentation(imageToPost.image!, 9.9)
            
            let imageFile = PFFile(name: "imageProfile.jpg", data: imagePro!)
            
            user["photoProfile"] = imageFile
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                //DETENEMOS EL SPINNER (ANIMACION)
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                var errorMessage = ""
                //SI PUDO REGISTRAR EL USUARIO
                if error == nil
                {
                    // Signup successful
                    //ENVIA AL SIGUIENTE PANTALLA (SEGUE LOGIN)
                    //self.performSegueWithIdentifier("login", sender: self)
                    self.displayAlert("Signup Successful", message: "Your information is saved")
                }
                else
                {
                    //SI NO SE PUDO REGISTRAR, ALAMCENA EL ERROR EN ESTA VARIABLE
                    if let errorString = error!.userInfo["error"] as? String
                    {
                        errorMessage = errorString
                    }
                    //LLAMAR LA FUNCIONA PARA MOSTRAR ALERTA, Y ENVIAR EL MENSAJE QUE NOS PRODUJO EL ANTERIOR METODO
                    self.displayAlert("Failed Sign Up", message: errorMessage)
                }
            })

            
            
            
            
            
            
        }
        
    }
    
    
    
    //esconder la bateria y status en general
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.nameText.delegate = self
        self.usernameText.delegate = self
        self.passwordText.delegate = self
        self.emailText.delegate = self
        self.phoneText.delegate = self

        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        let nextTag = textField.tag+1
        let nextResp = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if nextResp != nil
        {
            nextResp?.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        
        return false;
    }
    
    
 
    
}
