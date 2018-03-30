//
//  swipleCell.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/30/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//


import SwipeCellKit
import UIKit



class SwipleCell: SwipeTableViewCell {
    
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
 
    func updateCell( nameLbl: String, indexLbl: Int) {
        self.nameLbl.text = nameLbl
        self.indexLbl.text = ("\(indexLbl)")
    }
    

    
    
}


