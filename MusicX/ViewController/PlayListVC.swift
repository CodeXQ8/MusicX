//
//  PlayListVC.swift
//  MusicX
//
//  Created by Nayef on 3/10/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlayListVC: UIViewController {

    /* IBOutlets */
    @IBOutlet weak var collectionView: UICollectionView!
    
    /* Global Variables */
    var stringURls = [String]()
    var names = [String]()
    var audioArray = [String]()
    var count : Int = 0
    var indexCell : Int = 0 ;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        parseJSON()
    }


    func parseJSON() {
        
        let  path = Bundle.main.path(forResource: "jsonLibrary", ofType: "json") as String!
        let jsonData = NSData(contentsOfFile: path!) as Data!
        do {
            var readableJSON = try JSON(data: jsonData! , options: JSONSerialization.ReadingOptions.mutableContainers)
            self.count = readableJSON["Songs"].count
            for i in 1...count {
                let name = readableJSON["Songs","Song\(i)","Name"].string
                let url = readableJSON["Songs","Song\(i)","UrlImage"].string
                let audioUrl = readableJSON["Songs","Song\(i)","UrlAudio"].string
                self.names.append(name!)
                self.stringURls.append(url!)
                self.audioArray.append(audioUrl!)
            }
        } catch {
            print(error)
        }
        
    }

}

extension PlayListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongsCell", for: indexPath) as? SongsCell else { return SongsCell() }
        
        cell.updateCell(songImageUrl:self.stringURls[indexPath.item], songName: self.names[indexPath.item], songTime: "21:02")
        cell.layout()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        performSegue(withIdentifier: "songViewControllerSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SongViewController = segue.destination as?  SongViewController {
            SongViewController.stringURls = self.stringURls
            SongViewController.names = self.names
            SongViewController.audioArray = self.audioArray
            SongViewController.indexCell = self.indexCell
        }
        
    }
    
}
