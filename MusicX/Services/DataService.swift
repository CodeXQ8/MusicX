//
//  DataService.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 1/22/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_SONGS = DB_BASE.child("Songs")
    
    var songName = [String]()
    var songsURL = [String]()
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_SONGS: DatabaseReference {
        return _REF_SONGS
    }
    
    
    func createDBSong(uid:String , SongData: Dictionary<String,Any>){
        _REF_BASE.child(uid).updateChildValues(SongData)
    }
    
    func uploadSong(name: String, urlAudio: String, urlImage: String){
        REF_SONGS.childByAutoId().updateChildValues(["Name":name,"AudioUrl":urlAudio , "ImageUrl": urlImage])
    }
    
    
    func getSongs(handler: @escaping (_ name: [String], _ url: [String]) -> ()) {

        REF_SONGS.observeSingleEvent(of: .value) { (snapshot) in
             guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for song in snapshot {
                
                let name = song.childSnapshot(forPath: "Name").value as? String
                self.songName.append(name!)
                let url = song.childSnapshot(forPath: "Url").value as? String
                self.songsURL.append(url!)
            }
                    handler(self.songName,self.songsURL)
            }
        }
    }
    
    
    
    
    
    
    
    

