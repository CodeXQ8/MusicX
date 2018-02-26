//
//  RealmData.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 2/24/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmData : Object {
    @objc dynamic var nameOfSong = ""
    @objc dynamic var index = " "
    @objc dynamic var songsData = Data()
    
}
