//
//  EditProfilViewController.swift
//  MyGram
//
//  Created by Javier Gomez on 3/7/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit

class EditProfilViewController: UIViewController {

    @IBOutlet var usernameText: UITextField!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    var username = ""
    var name = ""
    var password = ""
    var phone = ""
    var email = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        usernameText.text = username
        nameText.text = name
        passwordText.text = password
        phoneText.text = phone
        emailText.text = email
        
        
        
        navigationController!.navigationBar.barTintColor = UIColor(red:  114, green: 94, blue: 133, alpha: 1)



  //      tabBarController.tabBar.barTintColor = UIColor.brownColor()
        
    //    tabBarController.tabBar.tintColor = UIColor.yellowColor()
        
        
        
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
