//
//  UserCollectionViewCell.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/21/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import Firebase

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var verifiedUserImageView: UIImageView!
    
    
    func configureCellForUser(user: User){
        
        self.username.text = user.getFullname()
        downloadImageFromFirebase(urlString: user.profilePictureUrl)
        self.verifiedUserImageView.isHidden = !user.isVerified
        
    }
    
    
    func downloadImageFromFirebase(urlString: String){
        
        let storageRef = FIRStorage.storage().reference(forURL: urlString)
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                if let data = imageData {
                    DispatchQueue.main.async(execute: {
                        self.userImageView.image = UIImage(data: data)
                    })
                    
                }
            }
        }
    }
    
}
