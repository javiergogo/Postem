//
//  cell.swift
//  ParseStarterProject-Swift
//
//  Created by Javier Gomez on 2/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

//CLASE PARA CONTROLAR SOLO LA CELDA DE LA TABLA QUE ESTA EN LA PANTALLA DE YOUR FEED
class cell: UITableViewCell
{

    //RELACIONES DE LA IMAGEN QUE SE MOSTRARA EN LOS FEED, A QUIEN PERTENECE Y QUE MENSAJE DEJARON
    @IBOutlet var postedImage: UIImageView!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var message: UILabel!

    @IBOutlet var dates: UILabel!
    
    @IBOutlet var  profileImage: UIImageView!

}

    
   