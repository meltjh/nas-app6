//
//  User.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 09-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
