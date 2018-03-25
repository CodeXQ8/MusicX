//
//  PlayListVC.swift
//  MusicX
//
//  Created by Nayef on 3/10/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class PlayListVC: UIViewController {
    
    /* IBOutlets */
    @IBOutlet weak var collectionView: UICollectionView!
    
    /* Global Variables */
    //    var stringURls = [String]()
    //    var names = [String]()
    //    var audioArray = [String]()
    var count : Int = 0
    var indexCell : Int = 0 ;
    
    /* Realm Variables */
    let realm = try! Realm()
    var songs : Results<JsonRealm>?
    var exist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        parseJSON()
        loadJSONFromRealm()
        
        collectionView.reloadData()
    }
    
    
    func parseJSON() {
        
        let  path = Bundle.main.path(forResource: "jsonLibrary", ofType: "json") as String!
        let jsonData = NSData(contentsOfFile: path!) as Data!
        do {
            var readableJSON = try JSON(data: jsonData! , options: JSONSerialization.ReadingOptions.mutableContainers)
            self.count = readableJSON["Songs"].count
            for i in 1...count {
                let name = readableJSON["Songs","Song\(i)","Name"].string
                let stringurl = readableJSON["Songs","Song\(i)","UrlImage"].string
                let audioUrl = readableJSON["Songs","Song\(i)","UrlAudio"].string
                saveToRealm(name:name! , stringUrl: stringurl!, audioUrl: audioUrl!)

            }
        } catch {
            print(error)
        }
        
    }
    
    func loadJSONFromRealm(){
           songs = realm.objects(JsonRealm.self)
    }
    
    /// this function will not work the first time unless I remove the if exist commmand 
    func saveToRealm(name:String , stringUrl: String, audioUrl: String) {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let song = JsonRealm()
        song.names = name
        song.stringURl = stringUrl
        song.audioUrl = audioUrl
        checkIfFileExist(song: song)
        if exist == true {
        do {
            try realm.write {
                realm.add(song)
            }
        } catch
        {
            print("Can't save Json Data to Realm")
        }
        }
    }
    
    func checkIfFileExist(song: JsonRealm) {
        
        if songs != nil {
            for songTemp in songs! {
                if songTemp.names == song.names {
                    exist = true
                    break
                }
            }
        }
    }
    
    
}

extension PlayListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return songs?.count ?? 1
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongsCell", for: indexPath) as? SongsCell else { return SongsCell() }
        
        let songImgUrl = songs?[indexPath.item].stringURl ?? "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F3.jpg"
        let songName = songs?[indexPath.item].names ?? "There is no Songs"
        cell.updateCell(songImageUrl:songImgUrl, songName: songName , songTime: "21:02")
        cell.layout()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        performSegue(withIdentifier: "songViewControllerSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SongViewController = segue.destination as?  SongViewController {
            SongViewController.songs = songs
            SongViewController.indexCell = self.indexCell
        }
        
    }
    
}
