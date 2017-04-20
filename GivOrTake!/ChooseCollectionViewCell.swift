//
//  ChooseCollectionViewCell.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/27/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit

class ChooseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featimage: UIImageView!
    
    
    @IBOutlet weak var collegename: UILabel!
    
    var mychoose : Choose! {
        didSet {
            updatevalue()
        }
    }
    
    
    func updatevalue() {
        featimage.image = mychoose.featuredimage
        collegename.text = mychoose.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
}
