//
//  ReciterSurahs.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/28/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
import RealmSwift

class ReciterSurahs : Object {
    
    @objc dynamic var surahName = ""
    @objc dynamic var reciterImage = " "
    @objc dynamic var surahID : Int = 0
    var reciter = LinkingObjects(fromType: Reciters.self, property: "reciterSurahs")
}
