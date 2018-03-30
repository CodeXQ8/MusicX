//
//  SongListVC.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/28/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView
import SDWebImage
import SwipeCellKit

class SongListVC: UIViewController {
    
    
    var surahs : Results<ReciterSurahs>?
    var downloadedSurahs : Results<DownloadedSurahs>?
    
    @IBOutlet weak var nameOfReciterLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let realm = try! Realm()
    
    var locationString = String().self
    var indexCell = Int()
    var exist = false
    // var btnIndex = Int()
    
    var reciter : Reciters? {
        didSet{
            surahs = RealmManager.sharedInstance.loadSurahsFromRealm(reciter: reciter!)
            downloadedSurahs = RealmManager.sharedInstance.loadDownloadedSurahsFromRealm(reciter: reciter!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: ("\(indexCell)"))
        nameOfReciterLbl.text = ("\(indexCell)")
        
        tabelView.delegate = self
        tabelView.dataSource = self
        
        surahs = RealmManager.sharedInstance.loadSurahsFromRealm(reciter: reciter!)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentActionCtrl(_ sender: Any) {
        tabelView.reloadData()
    }
    
    
    
    
}


extension SongListVC : listCellDelegate {
    
    
    func saveBtnWasPressed(btnIndex: Int) {
        
        DataManager().saveTODiskAndGetLocuationString(audioString: surahs![btnIndex].reciterAudio) { (location, success) in
            self.locationString = location
            if success {
                DispatchQueue.main.async {
                    
                    let downloadedSurah = DownloadedSurahs()
                    downloadedSurah.surahName = self.surahs![btnIndex].surahName
                    downloadedSurah.nameOfFile = (location as NSString).lastPathComponent
                    
                    RealmManager.sharedInstance.checkIfFileExistInDownLoadedSurahs(downloadedSurah: downloadedSurah, downloadedSurahs: self.downloadedSurahs, exist: { (exist) in
                        if exist == false {
                            do {
                                try self.realm.write {
                                    self.reciter?.downloadedSurah.append(downloadedSurah)
                                }
                            } catch {
                                print("realm error in songListVC")
                            }
                            RealmManager.sharedInstance.saveDownloadedToRealm(downloadedSurah: downloadedSurah)
                        }
                    })
                    let alertController = SCLAlertView()
                    alertController.showCustom("Download", subTitle: "Song is downloaded", color:
                        #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) , icon: UIImage(named: "ic_favorite_48px")!)
                }
            }
        }
     //   tabelView.reloadData()
    }
    
    
}


extension SongListVC : UITableViewDelegate , UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentControl.selectedSegmentIndex{
            
        case 0:
            return (surahs?.count)!
        case 1:
            return (downloadedSurahs?.count)!
            
        default :
            break
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tabelView.dequeueReusableCell(withIdentifier: "listCell") as? listCell else { return listCell() }
       
        guard let swipleCell = tabelView.dequeueReusableCell(withIdentifier: "swipleCell") as? SwipleCell else { return SwipleCell() }
        
        switch segmentControl.selectedSegmentIndex{
           
        case 0:
            if let surah = surahs?[indexPath.row] {
                cell.updateCell(nameLbl: surah.surahName , indexLbl: indexPath.row)
                cell.saveBtn.tag = indexPath.row
                cell.delegate = self
              return  cell
            }
            break 
        case 1:
            print(segmentControl.selectedSegmentIndex)
            
            if let downloadedSurah = downloadedSurahs?[indexPath.row] {
                swipleCell.updateCell(nameLbl: downloadedSurah.surahName , indexLbl: indexPath.row)
                swipleCell.delegate = self
            } else {
                swipleCell.updateCell(nameLbl:"No Surah" , indexLbl: indexPath.row)
            }
            return  swipleCell
        default :
            cell.updateCell(nameLbl:"No Surah" , indexLbl: indexPath.row)
        }
        return  UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        performSegue(withIdentifier: "songViewControllerSegue", sender: self)
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SongViewController = segue.destination as?  SongViewController {
            SongViewController.indexCell = self.indexCell
            SongViewController.reciter = self.reciter
        }
        
        if let DownloadedSurahsVC = segue.destination as? DownloadedSongsVC {
            DownloadedSurahsVC.reciter = self.reciter
        }
        
    }
    
}


extension SongListVC : SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if segmentControl.selectedSegmentIndex == 1 {
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                print("Deleted Cell")
                if let nameOfFile = self.downloadedSurahs?[indexPath.row].nameOfFile {
                    DataManager().deleteFilesFromDirectory(fileName: nameOfFile, handler: { (success) in
                        if success {
                            DispatchQueue.main.async {
                                let alertController = SCLAlertView()
                                
                                alertController.showCustom("Delete", subTitle: "Song is deleted", color:
                                    #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) , icon: UIImage(named: "ic_favorite_48px")!)
                                
                                
                                do {
                                    let surah = self.downloadedSurahs?[indexPath.row]
                                    try self.realm.write {
                                        self.realm.delete(surah!)
                                    }
                                } catch {
                                    print("Couldn't move from realm")
                                }
                             
                            }
                        }
                    })
                    
                    
        
                }
                
            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete")
            
            return [deleteAction]
        }else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        if segmentControl.selectedSegmentIndex == 1 {
            var options = SwipeTableOptions()
            options.expansionStyle = .destructive
            options.transitionStyle = .border
            return options
        }
        return SwipeTableOptions()
    }}
