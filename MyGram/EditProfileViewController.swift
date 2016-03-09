//
//  EditProfileViewController.swift
//  MyGram
//
//  Created by Javier Gomez on 3/8/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

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

    override func viewDidLoad()
    {
        super.viewDidLoad()

        userTxt.text = username
        nameTxt.text = name
        phoneTxt.text = phone
        emailTxt.text = email
        passTxt.text = password
        
   
        
        //UINavigationBar.appearance().backgroundColor = UIColor.blackColor()
//        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//
//        UINavigationBar.appearance().titleTextAttributes =  [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        
//        UINavigationBar.appearance().barTintColor = UIColor(red: 55.0/255.0, green: 143.0/255.0, blue: 243.0/255.0, alpha: 1)

        //UITabBar.appearance().backgroundColor = UIColor.yellowColor();

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
