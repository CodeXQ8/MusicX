//
//  headerCell.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/28/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit

class headerCell: UITableViewCell {

    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var songNameLbl: UILabel!
    
    func updateCell( imageHeader: String ,songName: String){
      
            self.imageHeader.image = UIImage(named: imageHeader)
            self.songNameLbl.text = songName
        }

    func layout() {
        self.imageHeader.layer.cornerRadius = 30
        self.imageHeader.layer.shadowRadius = 100
    }
}
