//
//  SavedItem.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 09-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import Foundation
import Firebase

struct SavedItem {
    let productId: String
    let savedByUser: String
    let ref: FIRDatabaseReference?
    
    init(productId: String, savedByUser: String) {
        self.productId = productId
        self.savedByUser = savedByUser
        self.ref = nil
    }
    
    /// Returns the object in a Firebase accepted format.
    func toAnyObject() -> Any {
        return [
            "productId": productId,
            "savedByUser": savedByUser,
        ]
    }
    
}
