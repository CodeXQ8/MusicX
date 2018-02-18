//
//  Slider.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 2/17/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit

@IBDesignable class Slider: UISlider {
    

    @IBInspectable var thumb : UIImage?{
        didSet{
           setThumbImage(thumb, for: .normal)
        }
    }
    
    @IBInspectable var thumbHighlited : UIImage?{
        didSet{
            setThumbImage(thumbHighlited, for: .highlighted)
        }
    }

}
