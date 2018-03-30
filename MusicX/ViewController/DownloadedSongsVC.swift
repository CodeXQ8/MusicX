//
//  DownloadedSongsVC.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/11/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import SCLAlertView

class DownloadedSongsVC: UIViewController {
    
    /* IBOutlets */
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    /*  Variables Related to PlayListVC */
    var stringURls = [String]()
    var names = [String]()
    var audioArray = [String]()
    var indexCell : Int = 0 ;
    
    /* Global Variables */
    let realm = try! Realm()
    var downloadedSurahs : Results<DownloadedSurahs>?
    
    
    
    var reciter : Reciters? {
        didSet{
        downloadedSurahs = RealmManager.sharedInstance.loadDownloadedSurahsFromRealm(reciter: reciter!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    

    
    
    
}



extension DownloadedSongsVC : UITableViewDataSource, UITableViewDelegate , SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedSurahs?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! savedSongCell
        cell.delegate = self
        
        let surahImage = downloadedSurahs?[indexPath.row].surahImage ?? "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F3.jpg"
        let surahName = downloadedSurahs?[indexPath.row].surahName ?? "There is no Songs"
        
        cell.layout()
        cell.updateCell(songImageUrl: surahImage, songName: surahName, songTime: "21:02")
        
        return cell
        
        
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! headerCell
//        headerCell.updateCell(imageHeader: "1", songName: "String")
//        headerCell.layout()
//        return headerCell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 70
//    }
//
// 
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return "Hey"
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Deleted Cell")
            if let suranName = self.downloadedSurahs?[indexPath.row].nameOfFile {
                DataManager().deleteFilesFromDirectory(fileName: suranName, handler: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            let alertController = SCLAlertView()

                            alertController.showCustom("Delete", subTitle: "Song is deleted", color:
                                #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) , icon: UIImage(named: "ic_favorite_48px")!)
                        }
                    }
                })
     
                
                
                do {
                    let song = self.downloadedSurahs?[indexPath.row]
                    try self.realm.write {
                        self.realm.delete(song!)
                    }
                } catch {
                    print("Couldn't move from realm")
                }
                   tableView.reloadData()
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        performSegue(withIdentifier: "songViewControllerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SongViewController = segue.destination as?  SongViewController {
            SongViewController.indexCell = downloadedSurahs?[indexCell].surahID ?? 1
        }
        
    }
    
}

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.indexCell = indexPath.item
//        performSegue(withIdentifier: "songViewControllerSegue", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let SongViewController = segue.destination as?  SongViewController {
//            SongViewController.indexCell = downloadedSongs[indexCell].songID
//        }







//extension DownloadedSongsVC: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return downloadedSongs.count
//    }
////
////    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
////        cell.delegate = self
////        return cell
////    }
//
//
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongsCell", for: indexPath) as? SongsCell else { return SongsCell() }
//        let song = downloadedSongs[indexPath.item]
//
//        cell.updateCell(songImageUrl: song.imageURL, songName: song.nameOfSong, songTime: "21:02")
//        cell.layout()
//        return cell
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.indexCell = indexPath.item
//        performSegue(withIdentifier: "songViewControllerSegue", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let SongViewController = segue.destination as?  SongViewController {
//            SongViewController.indexCell = downloadedSongs[indexCell].songID
//        }
//
//    }
//
//}

