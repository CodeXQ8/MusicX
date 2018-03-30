//
//  downloadedSurah.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/29/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
import RealmSwift

class DownloadedSurahs : Object {
    
    @objc dynamic var surahName = ""
    @objc dynamic var surahImage = ""
    @objc dynamic var nameOfFile = ""
    @objc dynamic var surahID : Int = 0
    
}
