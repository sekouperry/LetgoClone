//
//  UserProfileViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/21/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class UserProfileViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastnameTextfield: CustomizableTextfield!
    @IBOutlet weak var firstnameTextField: CustomizableTextfield!
    @IBOutlet weak var userProfileImageView: CustomizableImageView!
    
    var netService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchCurrentUserInfo()
    }
    
    
    private func fetchCurrentUserInfo(){
        netService.fetchCurrentUser { (user) in
            if let user = user {
                
                self.emailLabel.text = user.email
                self.firstnameTextField.text = user.firstname
                self.lastnameTextfield.text = user.lastname
                self.userProfileImageView.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
                
            }
        }
        
        
    }
    
    
    

}
