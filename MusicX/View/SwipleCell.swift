//
//  swipleCell.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/30/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//


import SwipeCellKit
import UIKit


protocol SwipleCellDelegate {
    
    func saveBtnWasPressed(btnIndex: Int)
}


class SwipleCell: SwipeTableViewCell {
    
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var swipleCellDelegate : SwipleCellDelegate?
    
    func updateCell( nameLbl: String, indexLbl: Int) {
        self.nameLbl.text = nameLbl
        self.indexLbl.text = ("\(indexLbl)")
    }
    
    
    @IBAction func saveBtnWasPressed(_ sender: UIButton) {
        swipleCellDelegate?.saveBtnWasPressed(btnIndex: sender.tag)
    }
    
    
    
}


