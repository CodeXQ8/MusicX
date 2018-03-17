//
//  savedSongVC.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 2/24/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class savedSongVC: UIViewController {

    let realm = try! Realm()
    var songs : Results<RealmData>!
    var AVplayer : AVPlayer!
    var AVplayerItem : AVPlayerItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        getpath()
  
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    

    func getpath(){
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let audioPath = paths[0]
        print(paths)
    }
       var i = 0
    @IBAction func playSONG(_ sender: Any) {
        
        let url = URL(fileURLWithPath: songs[2].index)
        print(songs[i].index)
        let asset = AVAsset(url: url)
        AVplayerItem =  AVPlayerItem(asset: asset)
        AVplayer = AVPlayer(playerItem: AVplayerItem)
        AVplayer.play()
        i = i + 1
    }
    
    
    
    
    func loadData() {
        songs = realm.objects(RealmData.self)
        tableView.reloadData()
    }

}


extension savedSongVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(RealmData.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "savedSongCell", for: indexPath) as? savedSongCell else { return savedSongCell() }

     //   cell.nameofSong.text = songs[indexPath.row].nameOfSong
        return cell
    }
    
    
}

//        let filePath = "\(dirFile)/mishary-rashid-alafasy-001-al-fatiha-30-7477.mp3"     // Try to Save name of the files to Realm so U can delete very faster
