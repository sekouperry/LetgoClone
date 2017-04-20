//
//  Users.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/24/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import Foundation
import Firebase

struct Users {
    
    //creating a users
    
    var email: String! = ""
    var firstname: String = ""
    var lastname: String = ""
    var uid: String! = ""
    var profilePictureUrl: String = ""
    var type:Int = 0 // 0: Wagner, 1: Monmouth
    
    var ref: FIRDatabaseReference! = nil
    var key: String = ""
    var isVerified: Bool = false
    
    
    
    init(snapshot: FIRDataSnapshot){
        
        if let dict = snapshot.value as? NSDictionary {
            
            self.email = dict["email"] as? String ?? ""
            self.firstname = dict["firstname"] as? String ?? ""
            self.lastname = dict["lastname"] as? String ?? ""
            self.uid = dict["uid"] as! String
            
            self.profilePictureUrl = dict["profilePictureUrl"] as? String ?? ""
            
            self.type = dict["type"] as? Int ?? 0
            
            self.ref = snapshot.ref
            self.key = snapshot.key
            self.isVerified = dict["isVerified"] as? Bool ?? false
        }
        
    }
    
    
    init(email: String, firstname: String, lastname: String, uid: String, profilePictureUrl: String, type: Int) {
        
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.uid = uid
        self.profilePictureUrl = profilePictureUrl
        self.type = type
        
        self.ref = FIRDatabase.database().reference()
        
    }
    
    func getFullname() -> String {
        
        return "\(firstname) \(lastname)"
    }
    
    
    
    
    func toAnyObject() -> [String: Any] {
        
        return ["email": self.email,
                "firstname": self.firstname,
                "lastname": self.lastname,
                "uid": self.uid,
                "profilePictureUrl": profilePictureUrl,
                "type": "\(type)",
                "isVerified": self.isVerified]
    }
    

}
