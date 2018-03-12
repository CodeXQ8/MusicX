//
//  RealmManager.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/11/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
//    /* Global Variables */
//    let realm = try! Realm()
//    var songs: Results<DownloadedSong>!
//    
//    var exist = false
//    
//    /* Functions */
//    
//    func saveToRealm(nameOfSong:String, songID:Int,locationString:String, imageURL: String ) {
//        print(Realm.Configuration.defaultConfiguration.fileURL)
//        let song = DownloadedSong()
//        
//        song.nameOfSong = nameOfSong
//        let nameOfFile = (locationString as NSString).lastPathComponent
//        song.nameOfFile = nameOfFile
//        song.imageURL = imageURL
//        song.songID = songID
//        
//        do {                                     // Check if the file exisit before saveing
//            try realm.write {
//                checkIfFileExist(song: song)
//                if !exist {
//                    realm.add(song)
//                } else {
//                    print("song exist")
//                }
//            }
//        } catch {
//            print("couldn't save to Realm")
//        }
//    }
//    
//    func loadSongs(){
//        songs = realm.objects(DownloadedSong.self)
//        print(songs)
//    }
//    
//    func checkIfFileExist(song: DownloadedSong) {
//        
//        if songs != nil {
//            for songTemp in songs {
//                if songTemp.nameOfSong == song.nameOfSong {
//                    exist = true
//                    break
//                }
//            }
//        }
//    }
}
