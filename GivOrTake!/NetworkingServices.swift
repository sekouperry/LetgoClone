//
//  NetworkingServices.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/24/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import Foundation
import Firebase

struct NetworkingServices {
    
    var databaseRef: FIRDatabaseReference! {
        
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorageReference! {
        
        return FIRStorage.storage().reference()
    }
    
    
    
    
    func signUp(firstname: String, lastname:String, email: String,pictureData: Data,password:String, type: Int){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                
                self.setUserInfo(user: user, firstname: firstname, lastname: lastname, pictureData: pictureData,password: password, type: type)
                
            }
        })
        
    }
    
    private func setUserInfo(user: FIRUser!, firstname: String, lastname:String, pictureData: Data,password: String, type: Int){
        
        let profilePicturePath = "profileImage\(user.uid)image.jpg"
        let profilePictureRef = storageRef.child(profilePicturePath)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        profilePictureRef.put(pictureData, metadata: metaData) { (newMetadata, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = "\(firstname) \(lastname)"
                
                if let url = newMetadata?.downloadURL() {
                    changeRequest.photoURL = url
                }
                
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil {
                        
                        if type == 0 {
                            self.saveUserInfoToDb(user: user, firstname: firstname, lastname: lastname, password: password, type: type)
                        }
                        else {
                            self.saveMUUserInfoToDb(user: user, firstname: firstname, lastname: lastname, password: password, type: type)
                        }
                        
                    }else {
                        print(error!.localizedDescription)
                        
                    }
                })
                
            }
        }
        
        
        
    }
    
    
    
    private func saveUserInfoToDb(user: FIRUser!, firstname: String, lastname:String,password: String, type:Int){
        
        
        let userRef = databaseRef.child("STATENISLAND").child(user.uid)
        let newUser = Users(email: user.email!, firstname: firstname, lastname: lastname, uid: user.uid, profilePictureUrl: String(describing: user.photoURL!), type: type)
        
        userRef.setValue(newUser.toAnyObject()) { (error, ref) in
            if error == nil {
                print("\(firstname) \(lastname) has been signed up successfullt")
            }else {
                print(error!.localizedDescription)
            }
            
            
        }
        
        self.signIn(email: user.email!, password: password)
        
    }
    
    private func saveMUUserInfoToDb(user: FIRUser!, firstname: String, lastname:String,password: String, type:Int){
        
        
        let userRef = databaseRef.child("LONGBRANCH").child(user.uid)
        let newUser = Users(email: user.email!, firstname: firstname, lastname: lastname, uid: user.uid, profilePictureUrl: String(describing: user.photoURL!), type: type)
        
        userRef.setValue(newUser.toAnyObject()) { (error, ref) in
            if error == nil {
                print("\(firstname) \(lastname) has been signed up successfullt")
            }else {
                print(error!.localizedDescription)
            }
            
            
        }
        
        self.MUsignIn(email: user.email!, password: password)
        
    }
    
    func signIn(email: String, password: String){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if let user = user {
                    print("\(user.displayName!) has logged in successfully!")
                    
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    
                    UserDefaults.standard.set(1, forKey: "type")
                    UserDefaults.standard.synchronize()
                    
                    appDel.takeToWagner()
                    
                    
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
        })
        
    }
    
    func MUsignIn(email: String, password: String){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if let user = user {
                    print("\(user.displayName!) has logged in successfully!")
                    
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    
                    UserDefaults.standard.set(2, forKey: "type")
                    UserDefaults.standard.synchronize()
                    
                    appDel.takeToMonmouth()
                    
                    
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
        })
        
    }
    
    
    
    
    
    func MUfetchAllPosts(completion: @escaping ([Posts])->()){
        
        let postsRef = databaseRef.child("Monmouthpost")
        postsRef.observe(.value, with: { (Monmouthpost) in
            
            var resultArray = [Posts]()
            for post in Monmouthpost.children {
                
                let post = Posts(snapshot: post as! FIRDataSnapshot)
                resultArray.append(post)
            }
            completion(resultArray)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func fetchAllPosts(completion: @escaping ([Posts])->()){
        
        let postsRef = databaseRef.child("statenposts")
        postsRef.observe(.value, with: { (statenposts) in
            
            var resultArray = [Posts]()
            for post in statenposts.children {
                
                let post = Posts(snapshot: post as! FIRDataSnapshot)
                resultArray.append(post)
            }
            completion(resultArray)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func fetchAllComments(postId: String, completion: @escaping ([Comments])->()){
        
        let commentsRef = databaseRef.child("wagnercomments").queryOrdered(byChild: "postId").queryEqual(toValue: postId)
        
        commentsRef.observe(.value, with: { (wagnercomments) in
            
            var resultArray = [Comments]()
            for comment in wagnercomments.children {
                
                let comment = Comments(snapshot: comment as! FIRDataSnapshot)
                resultArray.append(comment)
            }
            completion(resultArray)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func MUfetchAllComments(postId: String, completion: @escaping ([Comments])->()){
        
        let commentsRef = databaseRef.child("monmouthcomments").queryOrdered(byChild: "postId").queryEqual(toValue: postId)
        
        commentsRef.observe(.value, with: { (monmouthcomments) in
            
            var resultArray = [Comments]()
            for comment in monmouthcomments.children {
                
                let comment = Comments(snapshot: comment as! FIRDataSnapshot)
                resultArray.append(comment)
            }
            completion(resultArray)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    func fetchNumberOfComments(postId: String, completion: @escaping (Int)->()){
        
        let commentsRef = databaseRef.child("wagnercomments").queryOrdered(byChild: "postId").queryEqual(toValue: postId)
        
        commentsRef.observe(.value, with: { (wagnercomments) in
            
            completion(Int(wagnercomments.childrenCount))
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func MUfetchNumberOfComments(postId: String, completion: @escaping (Int)->()){
        
        let commentsRef = databaseRef.child("monmouthcomments").queryOrdered(byChild: "postId").queryEqual(toValue: postId)
        
        commentsRef.observe(.value, with: { (monmouthcomments) in
            
            completion(Int(monmouthcomments.childrenCount))
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
    func fetchPostUserInfo(uid: String, completion: @escaping (Users?)->()){
        
        
        let userRef = databaseRef.child("STATENISLAND").child(uid)
        
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: Users = Users(snapshot: currentUser)
            completion(user)
            
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
    }
    
    
    func MUfetchPostUserInfo(uid: String, completion: @escaping (Users?)->()){
        
        
        let userRef = databaseRef.child("LONGBRANCH").child(uid)
        
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: Users = Users(snapshot: currentUser)
            completion(user)
            
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
    }
    
    func fetchAllUsers(completion: @escaping([Users])->Void){
        
        let usersRef = databaseRef.child("STATENISLAND")
        usersRef.observe(.value, with: { (STATENISLAND) in
            
            var resultArray = [Users]()
            for user in STATENISLAND.children {
                
                let user = Users(snapshot: user as! FIRDataSnapshot)
                let currentUser = FIRAuth.auth()!.currentUser!
                
                if user.uid != currentUser.uid {
                    resultArray.append(user)
                }
                completion(resultArray)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func MUfetchAllUsers(completion: @escaping([Users])->Void){
        
        let usersRef = databaseRef.child("LONGBRANCH")
        usersRef.observe(.value, with: { (LONGBRANCH) in
            
            var resultArray = [Users]()
            for user in LONGBRANCH.children {
                
                let user = Users(snapshot: user as! FIRDataSnapshot)
                let currentUser = FIRAuth.auth()!.currentUser!
                
                if user.uid != currentUser.uid {
                    resultArray.append(user)
                }
                completion(resultArray)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func logOut(completion: ()->()){
        
        
        if FIRAuth.auth()!.currentUser != nil {
            
            do {
                
                try FIRAuth.auth()!.signOut()
                
                UserDefaults.standard.set(0, forKey: "type")
                UserDefaults.standard.synchronize()
                
                completion()
            }
                
            catch let error {
                print("Failed to log out user: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    func fetchCurrentUser(completion: @escaping (Users?)->()){
        
        let currentUser = FIRAuth.auth()!.currentUser!
        
        let currentUserRef = databaseRef.child("STATENISLAND").child(currentUser.uid)
        
        currentUserRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: Users = Users(snapshot: currentUser)
            completion(user)
            
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
        
    }
    
    func MUfetchCurrentUser(completion: @escaping (Users?)->()){
        
        let currentUser = FIRAuth.auth()!.currentUser!
        
        let currentUserRef = databaseRef.child("LONGBRANCH").child(currentUser.uid)
        
        currentUserRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: Users = Users(snapshot: currentUser)
            completion(user)
            
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
        
    }
    
    func fetchGuestUser(ref:FIRDatabaseReference!, completion: @escaping (Users?)->()){
        
        
        ref.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: Users = Users(snapshot: currentUser)
            completion(user)
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
        
    }
    
    
    func downloadImageFromFirebase(urlString: String, completion: @escaping (UIImage?)->()){
        
        let storageRef = FIRStorage.storage().reference(forURL: urlString)
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                if let data = imageData {
                    completion(UIImage(data:data))
                    
                }
            }
        }
        
        
    }
    
    func savePostToDB(post: Posts, completed: @escaping ()->Void){
        
        let postRef = databaseRef.child("statenposts").childByAutoId()
        postRef.setValue(post.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let alertView = SCLAlertView()
                _ = alertView.showSuccess("Success", subTitle: "Post saved successfuly", closeButtonTitle: "Done", duration: 4, colorStyle: UIColor(colorWithHexValue: 0x3D5B94), colorTextButton: UIColor.white)
                completed()
            }
        }
        
    }
    
    func MUsavePostToDB(post: Posts, completed: @escaping ()->Void){
        
        let postRef = databaseRef.child("Monmouthpost").childByAutoId()
        postRef.setValue(post.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let alertView = SCLAlertView()
                _ = alertView.showSuccess("Success", subTitle: "Post saved successfuly", closeButtonTitle: "Done", duration: 4, colorStyle: UIColor(colorWithHexValue: 0x3D5B94), colorTextButton: UIColor.white)
                completed()
            }
        }
        
    }
    
    func saveCommentToDB(comment: Comments, completed: @escaping ()->Void){
        
        let postRef = databaseRef.child("wagnercomments").childByAutoId()
        postRef.setValue(comment.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let alertView = SCLAlertView()
                _ = alertView.showSuccess("Success", subTitle: "Comment saved successfuly", closeButtonTitle: "Done", duration: 4, colorStyle: UIColor(colorWithHexValue: 0x3D5B94), colorTextButton: UIColor.white)
                completed()
            }
        }
        
    }
    
    func MUsaveCommentToDB(comment: Comments, completed: @escaping ()->Void){
        
        let postRef = databaseRef.child("monmouthcomments").childByAutoId()
        postRef.setValue(comment.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let alertView = SCLAlertView()
                _ = alertView.showSuccess("Success", subTitle: "Comment saved successfuly", closeButtonTitle: "Done", duration: 4, colorStyle: UIColor(colorWithHexValue: 0x3D5B94), colorTextButton: UIColor.white)
                completed()
            }
        }
        
    }
    
    
    func uploadImageToFirebase(postId: String, imageData: Data, completion: @escaping (URL)->()){
        
        let postImagePath = "postImages/\(postId)image.jpg"
        let postImageRef = storageRef.child(postImagePath)
        let postImageMetadata = FIRStorageMetadata()
        postImageMetadata.contentType = "image/jpeg"
        
        
        postImageRef.put(imageData, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL = newPostImageMD?.downloadURL() {
                    completion(postImageURL)
                }
            }
        }
        
    }
    
    
    func uploadVideoToFirebase(postId: String, videoURL: NSURL, completion: @escaping (URL)->()){
        
        let postImagePath = "postImages/\(postId)video.mov"
        let postImageRef = storageRef.child(postImagePath)
        
        
        postImageRef.putFile(videoURL as URL, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postVideoURL = metadata?.downloadURL() {
                    completion(postVideoURL)
                }
            }
        }
        
    }
}

