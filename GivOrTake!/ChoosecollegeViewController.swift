//
//  ChoosecollegeViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/26/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit

class ChoosecollegeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionWagner(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showW", sender: self)
    }
    
    @IBAction func actionMonmouth(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showM", sender: self)
    }

}
