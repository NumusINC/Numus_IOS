//
//  Wallet.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 11/21/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import Foundation
import Firebase

class Wallet {
    
    var budget: Double
    var target: Double
    var startDate: TimeInterval
    var endDate: TimeInterval
    var name: String
    var token: String
    var balance: Double
    
    init(budget: Double, target: Double, startDate: TimeInterval, endDate:TimeInterval, name:String, balance: Double) {
        self.budget = budget
        self.target = target
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
        self.token = Token.init().token()
        self.balance = balance
    }
    
    func delete() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let user = Auth.auth()
        ref.child("Users/\(user.currentUser!.uid)/wallet/\(self.token)").setValue(nil)
    }
    
    func saveInFireBase(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let user = Auth.auth()
        ref.child("Users/\(user.currentUser!.uid)/wallet/\(self.token)").setValue(["balance":self.balance,
                                                                                    "budget":self.budget,
                                                                                    "startDate":self.startDate,
                                                                                    "endDate":self.endDate,
                                                                                    "name":self.name,
                                                                                    "token":self.token,
                                                                                    "target":self.target])
    }
}
