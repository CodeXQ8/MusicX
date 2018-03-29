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
    var reciters : Results<Reciters>?
    var exist = false
    var reciterName = " Nayef"
    var reciterImage = " XX "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        reciters =  RealmManager.sharedInstance.loadRecitersromRealm()
        parseJSON()
        
        collectionView.reloadData()
    }
    
    
    func parseJSON() {
        
        let  path = Bundle.main.path(forResource: "jsonLibrary", ofType: "json") as String!
        let jsonData = NSData(contentsOfFile: path!) as Data!
        do {
            var readableJSON = try JSON(data: jsonData! , options: JSONSerialization.ReadingOptions.mutableContainers)
            self.count = readableJSON["Reciters"].count
            for i in 0...count-1 {
                reciterName = readableJSON["Reciters","Reciter\(i)","Name"].string!
                reciterImage = readableJSON["Reciters","Reciter\(i)","ImageName"].string!
              //  let audioUrl = readableJSON["Songs","Song\(i)","UrlAudio"].string
                
                // create Reciters and save to Realm
                let reciter = Reciters()
                reciter.reciterName = reciterName
                reciter.reciterImage = reciterImage
                
                checkIfFileExist(reciter: reciter)
                if !exist {
                    RealmManager.sharedInstance.saveToRealmReciter(reciter: reciter)
                }
                
            }
        } catch {
            print(error)
        }
        
    }
    
    func checkIfFileExist(reciter: Reciters) {
        if reciters != nil {
            for reciterTemp in reciters! {
                if reciterTemp.reciterName == reciter.reciterName {
                    exist = true
                    break
                }
            }
        }
    }
    
    
}

extension PlayListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return reciters?.count ?? 1
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongsCell", for: indexPath) as? SongsCell else { return SongsCell() }
        
        let reciterImage = reciters?[indexPath.item].reciterImage ?? "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F3.jpg"
        let reciterName = reciters?[indexPath.item].reciterName ?? "There is no Songs"
        cell.updateCell(songName: reciterName , songTime: "21:02", reciterImage : reciterImage)
        cell.layout()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        performSegue(withIdentifier: "songListSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SongViewController = segue.destination as?  SongViewController {
            // SongViewController.songs = songs
            SongViewController.indexCell = self.indexCell
        }
        if let songListVC = segue.destination as? SongListVC {
            songListVC.indexCell = self.indexCell
        //    songListVC.reciters = reciters
        }
        
    }
    
}
