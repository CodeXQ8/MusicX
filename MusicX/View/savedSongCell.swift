//
//  savedSongCell.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 2/24/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import SwipeCellKit

class savedSongCell: SwipeTableViewCell{


    
    @IBOutlet weak var imgViewCell: UIImageView!
    @IBOutlet weak var nameOfSongLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    /* My Custom Cell */

    
    func updateCell( songImageUrl: String , songName: String, songTime:String){
        let url = URL(string: songImageUrl)
        let placeHolder = UIImage(named: "single-1")
        self.imgViewCell.sd_setImage(with: url, placeholderImage: placeHolder, options: .highPriority) { (image, error, cache, url) in
            if error != nil
            {
                print("error in seting the images SBWeb")
            }
            
            self.nameOfSongLbl.text = songName
            self.durationLbl.text = songTime
            
        }
    }
    
    func layout() {
        self.imgViewCell.layer.masksToBounds = true 
        self.imgViewCell.layer.cornerRadius = 30
        self.imgViewCell.layer.shadowRadius = 100
    }

    
    
    /* ***************** */
}
