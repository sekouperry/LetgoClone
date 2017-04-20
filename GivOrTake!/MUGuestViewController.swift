//
//  MUGuestViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/25/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import Firebase

class MUGuestViewController: UIViewController {

    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lasstnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var guestImageView: UIImageView!
    
    var ref: FIRDatabaseReference?
    var netService = NetworkingServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setGuestUserInfo()
    }
    
    
    private func setGuestUserInfo() {
        if let ref = ref {
            netService.fetchGuestUser(ref: ref, completion: { (user) in
                if let user = user {
                    
                    self.emailLabel.text = user.email
                    self.firstnameLabel.text = user.firstname
                    self.lasstnameLabel.text = user.lastname
                    self.guestImageView.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
                    
                }
            })
        }
    }
}
