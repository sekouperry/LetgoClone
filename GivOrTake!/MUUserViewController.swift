//
//  MUUserViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/25/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MUUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastnameTextfield: CustomizableTextfields!
    @IBOutlet weak var firstnameTextField: CustomizableTextfields!
    @IBOutlet weak var userProfileImageView: MUCustomizableImageViews!
    
    var netService = NetworkingServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchCurrentUserInfo()
    }
    
    
    private func fetchCurrentUserInfo(){
        netService.MUfetchCurrentUser{ (user) in
            if let user = user {
                
                self.emailLabel.text = user.email
                self.firstnameTextField.text = user.firstname
                self.lastnameTextfield.text = user.lastname
                self.userProfileImageView.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
                
            }
        }
        
        
    }
    


}
