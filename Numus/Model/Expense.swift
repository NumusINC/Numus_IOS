//
//  Expense.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 11/21/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import Foundation
import Firebase

class Expense {
    
    var name: String
    var value: Double
    var date: TimeInterval
    var type: String
    var token: String
    var isIncome: Bool
    var walletKey: String
    
    init(name:String, value:Double, date:TimeInterval, type:String, isIncome:Bool, walletKey:String) {
        self.name = name
        self.value = value
        self.date = date
        self.type = type
        self.token = Token.init().token()
        self.isIncome = isIncome
        self.walletKey = walletKey
    }
    
    func delete() {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("Users/\(user!.uid)/expense/\(self.token)").setValue(nil)
        
    }
    
    func saveInFireBase() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let user = Auth.auth()
        ref.child("Users/\(user.currentUser!.uid)/expense/\(self.token)").setValue(["name":self.name,
                                                                                   "value":self.value,
                                                                                   "date":self.date,
                                                                                   "type":self.type,
                                                                                   "token":self.token,
                                                                                   "isIncome":self.isIncome,
                                                                                   "walletKey":self.walletKey])
    }
    
    
    
}
