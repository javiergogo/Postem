//
//  ViewController.swift
//  MyGram
//
//  Created by Javier Gomez on 3/6/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//
import UIKit
import Parse

class ViewController: UIViewController {
    
 /*   var signupActive = true
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //funcion que llamaremos CADA QUE QUERAMOS UTILIZAR UNA ALERTA, SOLO ENVIAMOS UN TITULO Y UN MENSAJE, QUE ESTA FUNCION ESTA ESPERANDO
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    //BOTON PARA REGISTRAR
    @IBAction func signUp(sender: AnyObject)
    {
        //REVISA QUE EL NOMBRE DE USUARIO Y CONTRASENA NO ESTEN VACIOS
        if username.text == "" || password.text == "" {
            
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
            
            //SI EL BOTON DE REGISTRO FUE ACTIVADO
            //REGISTRAR LOS VALORES DE LAS CAJAS DE TEXTO EN LA BASE DE DATOS
            if signupActive == true
            {
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    //DETENEMOS EL SPINNER (ANIMACION)
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    //SI PUDO REGISTRAR EL USUARIO
                    if error == nil {
                        // Signup successful
                        //ENVIA AL SIGUIENTE PANTALLA (SEGUE LOGIN)
                        self.performSegueWithIdentifier("login", sender: self)
                    }
                    else
                    {
                        //SI NO SE PUDO REGISTRAR, ALAMCENA EL ERROR EN ESTA VARIABLE
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                        }
                        //LLAMAR LA FUNCIONA PARA MOSTRAR ALERTA, Y ENVIAR EL MENSAJE QUE NOS PRODUJO EL ANTERIOR METODO
                        self.displayAlert("Failed SignUp", message: errorMessage)
                    }
                })
            }
                
                
                //SI NO ESTA ACTIVO EL BOTON DE REGISTRAR, SERA LOGIN
            else
            {
                print (username.text)
                print (password.text)
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    //DETIENE LA ANIMACION (SPINNER)
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    //SI TENEMOS INFORMACION EN USER SIGNIFICA QUE ESTA ADENTRO
                    if user != nil {
                        // Logged In!
                        
                        //LLAMA A LA SIGUIENTE PANTALLA (LOGIN SEGUE)
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    }
                    else
                    {
                        //SI NO HAY DATOS ENVIAR EL ERROR QUE SE ENCONTRO A LA ALERTA
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed Login", message: errorMessage)
                    }
                    
                })
            }
        }
    }
    
    
    
    //AL PRESIONAR BOTON DE LOGIN
    @IBAction func logIn(sender: AnyObject) {
        
        //SI SE QUIERE REGISTRAR
        if signupActive == true {
            //CAMBIAR EL TITULO A LOG IN
            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            //CAMBIAR LA ETIQUETA A NOT REGISTERED
            registeredText.text = "Not registered?"
            
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
            
        } else {
            
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Already registered?"
            
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            
        }
    }
    
    override func viewDidLoad() {
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
    
    
    override func viewDidAppear(animated: Bool) {
        //
        if let navcontroller = self.navigationController
        {
            navcontroller.navigationBarHidden = true
            self.navigationController?.toolbarHidden = true
        }
        
        //EN CASO DE QUE YA ESTE LOGED IN, CADA QUE APAREZCA IRA AL LOGIN SEGUE
        if PFUser.currentUser() != nil {
            
            //self.performSegueWithIdentifier("login", sender: self)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } */
}
