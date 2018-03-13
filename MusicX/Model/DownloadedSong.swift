//
//  DownloadedSong.swift
//  MusicX
//
//  Created by Nayef on 3/10/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
import RealmSwift

class DownloadedSong : Object {
    @objc dynamic var nameOfSong = ""
    @objc dynamic var nameOfFile = " "
    @objc dynamic var imageURL = " "
    @objc dynamic var songID : Int = 0


}
