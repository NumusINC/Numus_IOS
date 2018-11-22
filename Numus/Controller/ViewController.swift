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
            print("uid: \(user.currentUser!.uid)")
            self.ref.child("Users/\(user.currentUser!.uid)/info").setValue(["name":user.currentUser!.displayName,"email":user.currentUser!.email])
            
            let currentWallet = Wallet.init(budget: 5000, target: 100, startDate: Date.init().timeIntervalSince1970, endDate: Date.init().timeIntervalSince1970, name: "IOS wallet", balance: 0)
            
            
            //currentWallet.saveInFireBase()
            //currentWallet.delete()
            let token = Token.init()
            
            let expense = Expense.init(name: "IPhone", value: 144000, date: Date.init().timeIntervalSince1970, type: "otros", isIncome: false, token: token.token(), walletKey: currentWallet.token)
            expense.saveInFireBase()
            //expense.value = 100
            //expense.saveInFireBase()
            
            
        }else{
            let alert = UIAlertController(title: "Oops!", message: "Tuvimos algunos problemas con el login, intentalo de nuevo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            print("No se pudo logear el usuario")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init the instance of the Database
        ref = Database.database().reference()
    }


}

