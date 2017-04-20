//
//  Comments.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/24/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import Foundation
import Firebase
//creating comments
struct Comments {
    var commentId: String!
    var postId: String!
    var userId: String!
    var commentText: String
    var commentImageURL: String
    var commentDate: NSNumber
    var ref: FIRDatabaseReference!
    var key: String = ""
    var type: String
    
    init(commentId: String,userId: String,commentText: String,postId: String ,commentImageURL: String,commentDate: NSNumber, key: String = "", type:String){
        self.commentId = commentId
        self.postId = postId
        self.commentDate = commentDate
        self.commentText = commentText
        self.commentImageURL = commentImageURL
        self.commentId = commentId
        self.userId = userId
        self.type = type
        self.ref = FIRDatabase.database().reference()
    }
    
    init(snapshot:FIRDataSnapshot!) {
        self.commentId = (snapshot.value! as! NSDictionary)["commentId"] as! String
        self.commentDate = (snapshot.value! as! NSDictionary)["commentDate"] as! NSNumber
        self.commentText = (snapshot.value! as! NSDictionary)["commentText"] as! String
        self.postId = (snapshot.value! as! NSDictionary)["postId"] as! String
        self.commentImageURL = (snapshot.value! as! NSDictionary)["commentImageURL"] as! String
        self.userId = (snapshot.value! as! NSDictionary)["userId"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.type = (snapshot.value! as! NSDictionary)["type"] as! String
        
    }
    
    func toAnyObject()->[String: Any] {
        return ["commentId":self.commentId,"commentDate":self.commentDate,"commentText":self.commentText,"commentImageURL":self.commentImageURL,"postId": self.postId, "userId":self.userId, "type": self.type]
    }

}
