//
//  SongVC.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 2/3/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import AVFoundation

import SoundWave

class SongVC: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameOfSong: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var audioView: AudioVisualizationView!
    
    var stringURls = [String]()
    var names = [String]()
    var audioArray = [String]()
    var index : Int = 0
    var ArrayOfData : Dictionary<String,Data> = [:]
    var ArrayOfUrlChecking = [URL]()
    
   
    
    var imageUrl = String()
    var name = String()
    var audioUrl = String()
    
    var isPlaying : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.audioView.meteringLevelBarWidth = 4.0
//        self.audioView.meteringLevelBarInterItem = 1.0
//        self.audioView.meteringLevelBarCornerRadius = 0.0
       
      //  getSongFromTheNetwork()
       
         imageUrl = stringURls[index]
         name = names[index]
         audioUrl = audioArray[index]
        imgView.sd_setImage(with: URL(string: imageUrl))
        nameOfSong.text = name
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // let songs = getSongFromTheNetwork()
    }
    
 
    @IBAction func leftBtn(_ sender: Any) {
        if index > 0{
        if self.isPlaying {
            self.audioPlayer.stop()
        }
        self.index = self.index - 1
        updateSongVC(index: self.index)
        getSongFromTheNetwork(completed: { (success) in
                if success {
                    self.playSongFunc()
                }
            })
            
    }
    }
    
    @IBOutlet weak var platSingBtn: UIButton!
    
    @IBAction func playSong(_ sender: Any) {
        if isPlaying == false {
            self.platSingBtn.setImage(UIImage(named: "ic_pause_48px"), for: UIControlState.normal)
            
            getSongFromTheNetwork(completed: { (success) in
                if success {
                    self.playSongFunc()
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SongVC.updateViewProgress), userInfo: nil, repeats: true)
                    self.updateViewProgress()

                }
            })
            isPlaying = true
        } else {
            self.platSingBtn.setImage(UIImage(named: "ic_play_arrow_48px"), for: UIControlState.normal)
            self.audioPlayer.stop()
            isPlaying = false
        }
    }
    
    @IBAction func rightBtn(_ sender: Any) {
        if index + 1 <= stringURls.count{
            if self.isPlaying {
                self.audioPlayer.stop()
            }
        self.index = self.index + 1
        updateSongVC(index: self.index)
            getSongFromTheNetwork(completed: { (success) in
                if success {
                    self.playSongFunc()
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SongVC.updateViewProgress), userInfo: nil, repeats: true)
                    self.updateViewProgress()
                }
            })

        }
    
    }
    
    


    // cache each data that is playing
    func getSongFromTheNetwork(completed: @escaping (Bool) ->Void ) {

       
            let audioURL1 = URL(string: self.audioArray[self.index])
            if !self.ArrayOfUrlChecking.contains(audioURL1!){
                self.ArrayOfUrlChecking.append(audioURL1!)
                DispatchQueue.main.async {
                    
                
            URLSession.shared.dataTask(with: audioURL1!, completionHandler: { (data, urlResponse, error) in
                if error != nil {
                    print(error)
                }else {
                
                    self.ArrayOfData["\(self.index)"] = data
                   completed(true)
                }
            }
        ).resume()
                }
            } else {
                completed(true)
        }
    }
    
    
    
    // try to create an array that hold each downloaded songs so we don't download it every time
    func playSongFunc(){
        
       // let audioUrl = URL(string: self.audioArray[self.index])
        
        if  let dataAudio = ArrayOfData["\(self.index)"] {
        do {
            self.audioPlayer = try AVAudioPlayer(data: dataAudio)
            self.audioPlayer.play()

        } catch {
            print(error)
            }
        }
    }
    
    
    @objc func updateViewProgress(){
        if audioPlayer.isPlaying {
            DispatchQueue.main.async {
                let time = Float(self.audioPlayer.currentTime/self.audioPlayer.duration)
                self.progressView.setProgress(time, animated: true)
                self.timeLbl.text = "\(self.audioPlayer.currentTime)"
            }
        }
    }
    
    
    
    func updateSongVC(index: Int)
    {
        self.nameOfSong.text = names[index]
        self.imageUrl = stringURls[index]
        self.imgView.sd_setImage(with:URL(string: self.imageUrl) )
        
    }
    
    func getSaveFileUrl(audioUrl: URL) -> URL{
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentURL?.appendingPathComponent(audioUrl.lastPathComponent)
        return fileURL!
    }
    
    
    
    func getSong(url : String) -> AVAudioPlayer {
        let audioUrl = URL(string: url)
        do {
            let dataUrl = try Data(contentsOf: audioUrl!)
            self.audioPlayer = try AVAudioPlayer(data: dataUrl)
        } catch {
            print(error)
        }
        return audioPlayer
    }
    
    func getImage(imageURL : String?) -> Data {
        let url = URL(string: imageUrl)
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            print(error)
        }
        return Data()
    }

}



//   self.progressView.progress = Float(self.audioPlayer.currentTime)
//                self.audioView.audioVisualizationMode = .write
//                self.audioPlayer.isMeteringEnabled = true            // Enable metering
//                self.audioPlayer.updateMeters()
//                let avgPower = self.audioPlayer.averagePower(forChannel: 0)
//                self.audioView.addMeteringLevel(avgPower)
// self.audioView.play(for: 5.0)





//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let file = directoryURL.appendingPathComponent(audioUrl, isDirectory: false)
//            return (file, [.createIntermediateDirectories, .removePreviousFile]) }
//
//        Alamofire.download(audioUrl, to: destination).responseData { (data) in
//            print("Download Compleate ")
//        }
//
////        Alamofire.download(audioUrl!).responseData { (data) in
////            do {
////                self.audioPlayer = try AVAudioPlayer(data: data)
////                self.audioPlayer.play()
////            } catch {
////                print(error)
////            }
////        }


//    func download(audioUrl:String) {
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let file = directoryURL.appendingPathComponent(audioUrl, isDirectory: false)
//            return (file, [.createIntermediateDirectories, .removePreviousFile])
//        }
