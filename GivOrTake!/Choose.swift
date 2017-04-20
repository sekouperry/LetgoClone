//
//  Choose.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/27/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import Foundation
import UIKit

class Choose {
    var title:String!
    var featuredimage:UIImage!
    
    
    init(title:String, featuredimage:UIImage) {
        self.title = title
        self.featuredimage = featuredimage
    }
    
    static func createList()->[Choose] {
        return[Choose(title: "Wagner College", featuredimage: (UIImage(named: "WagnerCollegeseahawk"))!),
               Choose(title: "Monmouth University", featuredimage: (UIImage(named: "MonHawks"))!)
        
        
        
        ]
    }
    
    
}
