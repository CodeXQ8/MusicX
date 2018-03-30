//
//  Reciters.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/28/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
import RealmSwift

class Reciters : Object {
    
    @objc dynamic var reciterName = ""
    @objc dynamic var reciterImage = " "
    var reciterSurahs = List<ReciterSurahs>()
    var downloadedSurah = List<DownloadedSurahs>()
    

}
