//
//  UserProfilesViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/24/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class UserProfilesViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastnameTextfield: CustomizableTextfields!
    @IBOutlet weak var firstnameTextField: CustomizableTextfields!
    @IBOutlet weak var userProfileImageView: CustomizableImageViews!
    
    var netService = NetworkingServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchCurrentUserInfo()
    }
    //fetching current user profile
    
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
