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

class SongListVC: UIViewController {

 
    var songs : Results<JsonRealm>!
   
    @IBOutlet weak var nameOfReciterLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tabelView: UITableView!
    
    let realm = try! Realm()
    var locationString = String().self
    var indexCell = Int()
    var exist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

      imageView.image = UIImage(named: "1")
       nameOfReciterLbl.text = ("\(indexCell)")
        
        tabelView.delegate = self
        tabelView.dataSource = self
        
    }


}

extension SongListVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tabelView.dequeueReusableCell(withIdentifier: "listCell") as? listCell else { return listCell() }
        cell.updateCell(nameLbl: songs?[indexPath.row].names ?? "No cell", indexLbl: indexPath.row)
        return  cell
    }
    
    
    
}
