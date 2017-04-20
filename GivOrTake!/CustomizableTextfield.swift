//
//  CustomizableTextfield.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/21/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import Foundation

@IBDesignable class CustomizableTextfield: UITextField {
    
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
