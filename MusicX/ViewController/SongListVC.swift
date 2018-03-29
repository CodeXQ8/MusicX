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

 
    var reciters : Results<JsonRealm>!
   
    @IBOutlet weak var nameOfReciterLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tabelView: UITableView!
    
    let realm = try! Realm()
    var locationString = String().self
    var indexCell = Int()
    var exist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: reciters[indexCell].stringURl)
        let placeHolder = UIImage(named: "single-1")
        self.imageView.sd_setImage(with: url, placeholderImage: placeHolder, options: .highPriority) { (image, error, cache, url) in
            if error != nil
            {
                print("error in setting the images SBWeb \(error)")
            }
        }
       nameOfReciterLbl.text = ("\(indexCell)")
        
        tabelView.delegate = self
        tabelView.dataSource = self
        
    }

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension SongListVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reciters?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tabelView.dequeueReusableCell(withIdentifier: "listCell") as? listCell else { return listCell() }
        cell.updateCell(nameLbl: reciters?[indexPath.row].names ?? "No cell", indexLbl: indexPath.row)
        cell.saveBtn.addTarget(self, action: #selector(saveSong), for: .touchUpInside)
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.indexCell = indexPath.item
                performSegue(withIdentifier: "songViewControllerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SongViewController = segue.destination as?  SongViewController {
                        SongViewController.songs = reciters
                        SongViewController.indexCell = self.indexCell
                    }

    }

    @objc func saveSong() {
        print("song saved")
    }
}
