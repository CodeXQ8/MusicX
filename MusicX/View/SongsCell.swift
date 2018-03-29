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

    
    
    func updateCell(songName: String, songTime:String, reciterImage : String){

        songImage.image = UIImage(named: reciterImage)
        self.songNameLbl.text = songName
    
}
    func layout() {
        self.songImage.layer.cornerRadius = 30
        self.songImage.layer.shadowRadius = 100
    }
    
    }


//let url = URL(string: songImageUrl)
//        self.songImage.sd_setImage(with: url, placeholderImage: placeHolder, options: .highPriority) { (image, error, cache, url) in
//            if error != nil
//            {
//                print("error in setting the images SBWeb \(error)")
//            }
