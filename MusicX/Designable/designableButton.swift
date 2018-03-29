//
//  designableButton.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/28/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit

@IBDesignable
class designableButton: UIButton {


    //        Button.layer.cornerRadius = 30
    //        Button.layer.shadowRadius = 3
    //        Button.layer.shadowOpacity = 0.7
    //        Button.layer.shadowOffset = CGSize(width: 0, height: 0)

    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 0.0 {

        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 0.0 {
        
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }


    
}
