//
//  ProfileViewController.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 10/31/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON


class ProfileViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    var ref: DatabaseReference!
    var objectArray = [Wallet]()
    

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func logOut(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            
        } catch let signOutError as NSError {
            
            let alert = UIAlertController(title: "Oops!", message: "Tenemos algunos problemas porfavor intente mas tarde", preferredStyle: .alert)
            
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let idx = indexPath.row
        cell.textLabel?.text = objectArray[idx].name
        
        cell.detailTextLabel?.text = "$ \(String(format: "%.1f", objectArray[idx].target))"
        
        if objectArray[idx].target < 0 {
            cell.detailTextLabel?.textColor = UIColor.red
        }else{
            cell.detailTextLabel?.textColor = UIColor.green
        }
        
        return cell
    }
    
    func loadWallets(){
        
        // Get all the wallets
        let userID = Auth.auth().currentUser!.uid
        self.objectArray.removeAll()
        
        ref.child("Users/\(userID)/wallet").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let data = snapshot.value as! NSDictionary
            for idx in data {
                let json = JSON(idx.value)
                let wallet = Wallet.init(budget: json["budget"].double!,
                                         target: json["target"].double!,
                                         startDate:json["startDate"].double!,
                                         endDate: json["endDate"].double!,
                                         name: json["name"].stringValue,
                                         token: json["token"].stringValue)
                self.objectArray.append(wallet)
                self.table.reloadData()
            }
            
        }) { (error) in
            let alert = UIAlertController(title: "Oops!", message: "Tenemos algunos problemas porfavor intente mas tarde", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Connect to firebase
        ref = Database.database().reference()
        
        // Get all the wallets
        let user = Auth.auth()
        
        loadWallets()
        nameLabel.text = user.currentUser?.displayName
        
        
    }
    
    
    
    

}
