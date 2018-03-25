//
//  SongsCell.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 1/26/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import SDWebImage


class SongsCell: UICollectionViewCell  {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var songTimeLbl: UILabel!
    
    
    func updateCell( songImageUrl: String , songName: String, songTime:String){
        let url = URL(string: songImageUrl)
         let placeHolder = UIImage(named: "single-1")
        self.songImage.sd_setImage(with: url, placeholderImage: placeHolder, options: .highPriority) { (image, error, cache, url) in
            if error != nil
            {
                print("error in setting the images SBWeb \(error)")
            }

        self.songNameLbl.text = songName
        self.songTimeLbl.text = songTime

    }
}
    func layout() {
        self.songImage.layer.cornerRadius = 30
        self.songImage.layer.shadowRadius = 100
    }
    
    }


