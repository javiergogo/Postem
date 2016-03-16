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

    
    @IBOutlet var showImage: UIImageView!

}
