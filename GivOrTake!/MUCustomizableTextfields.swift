//
//  MUCustomizableTextfields.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/26/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class MUCustomizableTextfields: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    
}
