//
//  ViewController.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 1/22/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var imgView: UIImageView!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DataService.instance.getSongs { (names, urls) in
//            do {
//
//                let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Audio%2F001-al-fatihah.mp3?alt=media&token=7d8a0e25-8fdc-4efe-9ad4-dcdd2b916604s")
//
//                self.audioPlayer = try AVAudioPlayer(contentsOf: url!)
//                        self.audioPlayer.play()
//
//            }catch {
//                print(error)
//            }
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func upLoadBtn(_ sender: Any) {
        
        
        
    //   DataService.instance.getSongs { (names, urls) in
          
                let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/musicx-d2c45.appspot.com/o/Audio%2F001-al-fatihah.mp3?alt=media&token=9f475271-c955-4b87-af9b-6f4faeccd307")
          
//                do {
//                    self.audioPlayer = try AVAudioPlayer(contentsOf: url!)
//                    self.audioPlayer.play()
//                } catch {
//                    print(error)
//                }
                
                let requset = NSMutableURLRequest(url: url!)
                
                URLSession.shared.dataTask(with: requset as URLRequest, completionHandler: { (data, nil, error) in

                    if error != nil {
                        print("error")
                    } else {
                        do {
                            self.audioPlayer = try AVAudioPlayer(data: data!)
                        self.audioPlayer.play()
                        } catch {
                            print(error)
                        }

                    }

                }).resume()

         
      //  }
        
        
        
      //  let url = URL(string: "https://i.stack.imgur.com/JNfzE.png")
//        do {
//            let data = try Data(contentsOf: url!)
//             let img = UIImage(data: data)
//            let imgePNG = UIImagePNGRepresentation(img!)
//
            //    StorageService.instance.uploadToStorage(name: "Nayef 5 ", url: url!)
//        }catch {
//            print(error)
//        }
    
        
      
        
        //DataService.instance.uploadSong(name: "Mishary", url: "www.google.com")
    }
    
    
//    func getImgae(){
//      //  DataService.instance.getSongs { (names, urls) in
//            do {
//
//                let url = URL(string: urls[1])
//                let data = try Data(contentsOf: (url)!)
//                //                let img = UIImage(data: data)
//                //                let imgePNG = UIImagePNGRepresentation(img!)
//                self.imgView.image = UIImage(data: data)
//
//            }catch {
//                print(error)
//            }
//       // }
//    }
    
}

