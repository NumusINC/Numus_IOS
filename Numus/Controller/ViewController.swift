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
            
            
            //save wallet in memory
            let token = Token.init()
            let currentWallet = Wallet.init(budget: 5000, target: 100, startDate: Date.init().timeIntervalSince1970, endDate: Date.init().timeIntervalSince1970, name: "IOS wallet", token: token.token())
            currentWallet.saveInFireBase()
            
            //Save in memory
            let defaults = UserDefaults.standard
            defaults.set(currentWallet.token, forKey: "currentWallet")
            
            //currentWallet.delete()
            //let expense = Expense.init(name: "IPhone", value: 144000, date: Date.init().timeIntervalSince1970, type: "otros", isIncome: false, token: token.token(), walletKey: currentWallet.token)
            //expense.saveInFireBase()
            //expense.value = 100
            //expense.saveInFireBase()
            
            
        }else{
            let alert = UIAlertController(title: "Oops!", message: "Tuvimos algunos problemas con el login, intentalo de nuevo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("No se pudo logear el usuario")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init the instance of the Database
        ref = Database.database().reference()
    }


}

