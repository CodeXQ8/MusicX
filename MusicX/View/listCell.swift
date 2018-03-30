//
//  listCel.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/28/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit


protocol listCellDelegate {
    
    func saveBtnWasPressed(btnIndex: Int)
}


class listCell: UITableViewCell {
    
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var delegate : listCellDelegate?
    
    func updateCell( nameLbl: String, indexLbl: Int) {
        self.nameLbl.text = nameLbl
        self.indexLbl.text = ("\(indexLbl)")
    }


    @IBAction func saveBtnWasPressed(_ sender: UIButton) {
        delegate?.saveBtnWasPressed(btnIndex: sender.tag)
    }
    
    

}
