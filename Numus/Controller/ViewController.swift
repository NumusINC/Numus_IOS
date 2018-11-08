//
//  ViewController.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 10/2/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    var ref: DatabaseReference!
    //ref = Database.database().reference()

    @IBAction func googleSingInBTN(_ sender: UIButton) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        let user = Auth.auth()
        
        if user.currentUser != nil {
            print("uid \(user.currentUser!.uid)")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }


}

