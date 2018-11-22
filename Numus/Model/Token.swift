//
//  Token.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 11/21/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import Foundation


class Token {
    
    
    init() {
        
    }
    
    func token() -> String {
        let array = Array("ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm1234567890")
        var token = ""
        for _ in 1...32 {
            let idx = Int.random(in: 0...array.count - 1)
            token.append(array[idx])
        }
        return token
    }
    
}
