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

class SongListVC: UIViewController {
    
    
    var surahs : Results<ReciterSurahs>?
    var downloadedsurahs : Results<DownloadedSurahs>?
    
    @IBOutlet weak var nameOfReciterLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tabelView: UITableView!
    
    
    let realm = try! Realm()
    
    var locationString = String().self
    var indexCell = Int()
    var exist = false
   // var btnIndex = Int()
    
    var reciter : Reciters? {
        didSet{
            surahs = RealmManager.sharedInstance.loadSurahsFromRealm(reciter: reciter!)
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
    
//    var success = Bool()
}


extension SongListVC : listCellDelegate {
  

    func saveBtnWasPressed(btnIndex: Int) {
        
        DataManager().saveTODiskAndGetLocuationString(audioString: surahs![btnIndex].reciterAudio) { (location, success) in
            self.locationString = location
            if success {
                DispatchQueue.main.async {
                    
                    let downloadedSurah = DownloadedSurahs()
                    downloadedSurah.surahName = self.surahs![btnIndex].surahName
                    downloadedSurah.nameOfFile = self.locationString
                    
                    RealmManager.sharedInstance.checkIfFileExistInDownLoadedSurahs(downloadedSurah: downloadedSurah, downloadedSurahs: self.downloadedsurahs, exist: { (exist) in
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
        
    }
    
    
}


extension SongListVC : UITableViewDelegate , UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surahs?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tabelView.dequeueReusableCell(withIdentifier: "listCell") as? listCell else { return listCell() }
        
        
        if let surah = surahs?[indexPath.row] {
            cell.updateCell(nameLbl: surah.surahName , indexLbl: indexPath.row)
            cell.saveBtn.tag = indexPath.row
            cell.delegate = self
        } else {
            cell.updateCell(nameLbl:"No Surah" , indexLbl: indexPath.row)
        }
        return  cell
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
