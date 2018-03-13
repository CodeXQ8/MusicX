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
    var downloadedSongs : Results<DownloadedSong>!
    
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
        downloadedSongs = realm.objects(DownloadedSong.self)
        print(downloadedSongs)
    }
    
    /* IBActions */
    
    @IBAction func deleteBtnWasPressed(_ sender: Any) {
        DataManager().deleteFilesFromDirectory(fileName: downloadedSongs[0].nameOfFile)      // Try to delete the cell at index
    }
    
}

extension DownloadedSongsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return downloadedSongs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongsCell", for: indexPath) as? SongsCell else { return SongsCell() }
        let song = downloadedSongs[indexPath.item]
        
        cell.updateCell(songImageUrl: song.imageURL, songName: song.nameOfSong, songTime: "21:02")
        cell.layout()
        return cell
        
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        performSegue(withIdentifier: "songViewControllerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SongViewController = segue.destination as?  SongViewController {
            SongViewController.indexCell = downloadedSongs[indexCell].songID
        }
        
    }
    
}
