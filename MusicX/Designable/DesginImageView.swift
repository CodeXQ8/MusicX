//
//  DesginImageView.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/26/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit

@IBDesignable
class DesginImageView: UIImageView {
    
    @IBInspectable var cornerRaduis : CGFloat = 0.0 {
        
        didSet {
            
            self.layer.cornerRadius = cornerRaduis
        }
    }
    
//    @IBInspectable var shadowRadius : CGFloat = 0.0 {
//        
//        didSet {
//            self.layer.shadowRadius = shadowRadius
//        }
//    }
//
//    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0.0, height: 0.0)
//        {
//
//        didSet {
//            self.layer.shadowOffset = shadowOffset
//        }
//    }
//
//    @IBInspectable var shadowColor : CGColor = UIColor.black.cgColor
//        {
//        didSet {
//            self.layer.shadowColor = shadowColor
//        }
//    }


    
}
