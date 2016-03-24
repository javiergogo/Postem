//
//  ViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/6/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//
import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    //esconder la bateria y status en general
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    var signupActive = true
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!

    
    
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
        
    
    //AL PRESIONAR BOTON DE LOGIN
    @IBAction func logIn(sender: AnyObject) {
        
        //REVISA QUE EL NOMBRE DE USUARIO Y CONTRASENA NO ESTEN VACIOS
        if username.text == "" || password.text == ""
        {
            displayAlert("Error in form", message: "Please enter a username and password")
        }
        else
        {
            //MOSTRARA EL SPINNER EN EL CENTRO
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            //CUANDO DETENGO EL INDICATOR LO ESCONDO AUTOMATICAMENTE
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            //ESTO IGNORARA CUALQUIER CLICK O ACTIVIDAD EN LA APLICACION, SE USARA ESTO PARA CUANDO LA APLICACION
            //TIENE ALGUNA TAREA PENDIENTE Y NO SE QUIERE QUE EL USUARIO CONTINUE USANDO LA APP
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"

       
            
            PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                //DETIENE LA ANIMACION (SPINNER)
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                //SI TENEMOS INFORMACION EN USER SIGNIFICA QUE ESTA ADENTRO
                if user != nil
                {
                    //LLAMA A LA SIGUIENTE PANTALLA (LOGIN SEGUE)
                    self.performSegueWithIdentifier("showMain", sender: self)
                    //print ("logged In")
                }
                else
                {
                    //SI NO HAY DATOS ENVIAR EL ERROR QUE SE ENCONTRO A LA ALERTA
                    if let errorString = error!.userInfo["error"] as? String
                    {
                        errorMessage = errorString
                    }
                    
                    var alert = UIAlertController(title:"We do not have records of your username", message:errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "Sign Up", style: .Default, handler: { (action: UIAlertAction!) in
                        self.performSegueWithIdentifier("showSignup", sender:self)
                    }))

                    
                    alert.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { (action: UIAlertAction!) in
                        //println("Handle Cancel Logic here")
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
   }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato", size: 17)!]
        
        self.username.delegate = self
        self.password.delegate = self

        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidAppear(animated: Bool) {
        //            navigationController?.setNavigationBarHidden(true, animated: true)

        if let navcontroller = self.navigationController
        {
            navcontroller.navigationBarHidden = true
            self.navigationController?.toolbarHidden = true
        }
        
        if let navbar = self.tabBarController
        {
            self.hidesBottomBarWhenPushed = true
            self.tabBarController!.tabBar.hidden = true

        }
        
        //EN CASO DE QUE YA ESTE LOGED IN, CADA QUE APAREZCA IRA AL LOGIN SEGUE
        if PFUser.currentUser()?.username != nil
        {
            self.performSegueWithIdentifier("showMain", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
