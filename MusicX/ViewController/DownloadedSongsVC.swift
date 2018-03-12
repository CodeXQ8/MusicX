//
//  DownloadedSongsVC.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/11/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import RealmSwift

class DownloadedSongsVC: UIViewController {

    /* IBOutlets */
    @IBOutlet weak var collectionView: UICollectionView!
    
    /*  Variables Related to PlayListVC */
    var stringURls = [String]()
    var names = [String]()
    var audioArray = [String]()
    var indexCell : Int = 0 ;
    
    /* Global Variables */
    let realm = try! Realm()
    var songs : Results<DownloadedSong>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        loadSongs()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
   
    func loadSongs(){
        songs = realm.objects(DownloadedSong.self)
        print(songs)
    }
    
    /* IBActions */
    
    @IBAction func deleteBtnWasPressed(_ sender: Any) {
        DataManager().deleteFilesFromDirectory(fileName: songs[0].nameOfFile)      // Try to delete the cell at index
    }
    
}

extension DownloadedSongsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return songs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongsCell", for: indexPath) as? SongsCell else { return SongsCell() }
        let song = songs[indexPath.item]
        
        cell.updateCell(songImageUrl: song.imageURL, songName: song.nameOfSong, songTime: "21:02")
        cell.layout()
        return cell
        
    }


    
    
}
