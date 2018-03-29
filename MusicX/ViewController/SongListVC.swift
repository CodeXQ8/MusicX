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
   
    @IBOutlet weak var nameOfReciterLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tabelView: UITableView!
    
    let realm = try! Realm()
    
    var locationString = String().self
    var indexCell = Int()
    var exist = false
    
    
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
    
    
}

extension SongListVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surahs?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tabelView.dequeueReusableCell(withIdentifier: "listCell") as? listCell else { return listCell() }
        
        if let surah = surahs?[indexPath.row] {
        cell.updateCell(nameLbl: surah.surahName , indexLbl: indexPath.row)
        cell.saveBtn.addTarget(self, action: #selector(saveSong), for: .touchUpInside)
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
                     //   SongViewController.songs = surahs
                        SongViewController.indexCell = self.indexCell
                    }

    }

    @objc func saveSong() {
        print("song saved")
    }
}
