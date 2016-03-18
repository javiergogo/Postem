//
//  IndividualViewController.swift
//  Postem
//
//  Created by Javier Gomez on 3/12/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit


class IndividualViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagen = imagenEscogida.miImagen
    
        showImage.image = imagen
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {

        print (showImage.image)
    
        performSegueWithIdentifier("starsharing", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //PREGUNTAMOS SI EL IDENTIFICADOR ES IGUAL A LOGOUTRIDER ENTONCES HAZ ESO (LOGOUT)
        if segue.identifier == "starsharing"
        {
            if let destination = segue.destinationViewController as? SharingTableViewController
            {
                let image = self.showImage.image!
                destination.imagen = UIImageView(image: image)
                print (destination.imagen)
                print (self.showImage.image)
            }
            
        }
        
        
    }
    
    
    
    @IBOutlet var showImage: UIImageView!

}
