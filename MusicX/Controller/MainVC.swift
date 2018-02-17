//
//  MainVC.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 1/26/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class MainVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var count : Int = 0
    var urls = [URL]()
    var stringURls = [String]()
    var names = [String]()
    var audioArray = [String]()
    
    var image =  String()
    var name = String()
    var audio = String()
    var index : Int = 0 ;
    
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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }

    @IBAction func addSongBtn(_ sender: Any) {
        
    
    }
 
    
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        
        self.index = indexPath.item
        
        performSegue(withIdentifier: "SongSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let songVC = segue.destination as?  SongVC {
            songVC.stringURls = self.stringURls
            songVC.names = self.names
            songVC.audioArray = self.audioArray
            songVC.index = self.index
        }
        
    }
    
}






























///////////////////
//    var urls : [String] = ["https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F1.jpg?alt=media&token=b819b9e1-9cc3-4fbf-b968-2e691f5cadcd",
//                           "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F3.jpg?alt=media&token=a986a3ed-4023-45a5-9f90-339cd5462899",
//                          "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F0.png?alt=media&token=d0935e0b-ed83-479c-8492-b45a0b87849b","https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F0.png?alt=media&token=d0935e0b-ed83-479c-8492-b45a0b87849b",
//                          "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F0.png?alt=media&token=d0935e0b-ed83-479c-8492-b45a0b87849b",
//                          "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F0.png?alt=media&token=d0935e0b-ed83-479c-8492-b45a0b87849b",
//                        ]
    
    
////////////////////
//        for i in 0...4 {
//        StorageService.instance.REF_IMG.child("\(self.i).jpg").downloadURL { (url, error) in
//            if error != nil {
//                print( " Qqqqqqqqqqqq" )
//            } else {
////                do {
////                let urlString = try String(contentsOf: url!)
////                    self.urls.append(urlString)
////                } catch {
////                    print( " Ssssssssssss" )
////                }
//
//              //  print("\(urls[i+1]) +  Number \(i)" )
//            }
//        }
//
//        }

///////////////////



/// ADD SONG

//        StorageService.instance.getUrls { (urls) in
//            print(urls[1])
//            self.i = self.i + 1
//        }
//        let url = URL(fileURLWithPath: "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Image%2F0.png?alt=media&token=d0935e0b-ed83-479c-8492-b45a0b87849b")
//
//        StorageService.instance.uploadImgToStorage(name: "HM\(self.i)", url: url)
//        self.i = self.i + 1

//StorageService.instance.REF_IMG.child("\(self.i).jpg").downloadURL { (url, error) in
//    if error != nil {
//        print(error)
//    } else {
//        self.urls.append(url!)
//        print("\(self.urls[self.i+1]) +  Number \(self.i)" )
//    }
//}
//self.i = self.i + 1

