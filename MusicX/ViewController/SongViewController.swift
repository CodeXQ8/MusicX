//
//  SongViewController.swift
//  MusicX
//
//  Created by Nayef on 3/10/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import SCLAlertView
import MediaPlayer

class SongViewController: UIViewController {
    
    /* IBOutlets */
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var NameOfAudio: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var slider: Slider!
    
    /*  Variables Related to PlayListVC */
//    var stringURls = [String]()
//    var names = [String]()
//    var audioArray = [String]()
    var indexCell : Int = 0 ;
    
    /* Global Variables */
    var audioplayerItem : AVPlayerItem!
    var player : AVPlayer?
    
    let realm = try! Realm()
   // var songs : Results<DownloadedSong>!
    var songs : Results<JsonRealm>!
    var downloadedSongs : Results<DownloadedSong>!
    
    var exist = false
    
    var locationString = String().self
    
    var updater : CADisplayLink! = nil
    
    var imageString = String()
    var name = String()
    var audioString = String()
    
    var isPlaying : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSongs()
        
        imageString = songs[indexCell].stringURl
        name = songs[indexCell].names
        audioString = songs[indexCell].audioUrl
        
        songImageView.sd_setImage(with: URL(string: imageString))
        NameOfAudio.text = name
        
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//        self.becomeFirstResponder()
//        setupAudioSession()
        //setupLockScreen()
//
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
//            print("Playback OK")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
//        } catch {
//            print(error)
//        }
        
    }
    
    func setupAudioSession(){
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
//            do {
//                try AVAudioSession.sharedInstance().setActive(true)
//                print("AVAudioSession is Active")
//            } catch let error as NSError {
//                print(error.localizedDescription)
//                
//            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    /* IBActions */
    
    @IBAction func BackBtnWasPressed(_ sender: Any) {
        if player?.rate != 0 {
            self.player?.pause()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var playBtnOutLet: UIButton!
    @IBAction func playBtnWasPressed(_ sender: Any) {
        if isPlaying == false {
            playBtnOutLet.setImage(UIImage(named: "ic_pause_48px"), for: UIControlState.normal)
            startPlaying()
            updater = CADisplayLink(target: self, selector: #selector(SongViewController.updateSliderValue))   // Updating Slider Using CADisplay
            updater.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            isPlaying = true
        } else {
            playBtnOutLet.setImage(UIImage(named: "ic_play_arrow_48px"), for: UIControlState.normal)
            player?.pause()
            isPlaying = false
            
        }
        
        
    }
    
    
    /*  AudioPlayer Lock Control */
    
    func setupLockScreen(){
        
//        let commandCenter = MPRemoteCommandCenter.shared()
//        commandCenter.playCommand.isEnabled = true
//        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
//            if self.player?.rate == 0.0 {
//                self.player?.play()
//                return .success
//            }
//            return .commandFailed
//        }
//        commandCenter.pauseCommand.isEnabled = true
//        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
//            if self.player?.rate != 0.0 {
//                self.player?.pause()
//                return .success
//            }
//            return .commandFailed
//        }
//        commandCenter.nextTrackCommand.isEnabled = true
//        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
//            if self.player?.rate != 0.0 {
//               print("next")
//                return .success
//            }
//            return .commandFailed
//        }
//        commandCenter.previousTrackCommand.isEnabled = true
//        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
//            if self.player?.rate != 0.0 {
//                print("previousTrackCommand")
//                return .success
//            }
//            return .commandFailed
//        }
//        commandCenter.skipBackwardCommand.isEnabled = false
//        commandCenter.skipForwardCommand.isEnabled = false
        
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "My Song"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Artist"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "MPMediaItemPropertyAlbumTitle"
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioplayerItem.duration.seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioplayerItem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    //   commandCenter.playCommand.addTarget(self, action: #selector(SongViewController.playCommandS))

    @objc func playCommandS() {
        print("Play Command")
    }
    /////////////////////////////

    
    @IBAction func downloadBtnWasPressed(_ sender: Any) {
        
        DataManager().saveTODiskAndGetLocuationString(audioString: audioString) { (location, success) in
            self.locationString = location
            if success {
                DispatchQueue.main.async {
                    self.saveToRealm(nameOfSong: self.songs[self.indexCell].names, songID : self.indexCell)
                    let alertController = SCLAlertView()

                    alertController.showCustom("Download", subTitle: "Song is downloaded", color:
                        #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) , icon: UIImage(named: "ic_favorite_48px")!)
                    
                    
                }
                

                        }
            }
        
        
          
 
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        if player != nil {
        let seconds : Int64 = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        player!.seek(to: targetTime)
        }
    }
    
    /* Functions for Realm*/
    
    func saveToRealm(nameOfSong:String, songID:Int) {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let song = DownloadedSong()

        song.nameOfSong = nameOfSong
        let nameOfFile = (locationString as NSString).lastPathComponent
        song.nameOfFile = nameOfFile
        song.imageURL = songs[indexCell].stringURl
        song.songID = songID

        do {                                     // Check if the file exisit before saveing
            try realm.write {
                checkIfFileExist(song: song)
                if !exist {
                    realm.add(song)
                } else {
                    print("song exist")
                }
            }
        } catch {
            print("couldn't save to Realm")
        }
    }
    
    func loadSongs(){
        songs = realm.objects(JsonRealm.self)
        downloadedSongs = realm.objects(DownloadedSong.self)
        print(songs)
    }

    func checkIfFileExist(song: DownloadedSong) {
        exist = false
        for songTemp in downloadedSongs {
            if songTemp.nameOfSong == song.nameOfSong {
                exist = true
                break
            }
        }
    }
    
    /* Functions for AVPlayer */
    
    func startPlaying() {
        
        let audioURL = URL(string: audioString)
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent((audioURL?.lastPathComponent)!)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists and it will play without network")
            setupAudioSession()
            self.audioplayerItem =  AVPlayerItem(url: destinationUrl)
            self.player = AVPlayer(playerItem: self.audioplayerItem)
            self.player?.play()
            setupLockScreen()
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()

        } else {
            print("The song  will play with network")
            let audioURL = URL(string: audioString)
            self.audioplayerItem =  AVPlayerItem(url: audioURL!)
            self.player = AVPlayer(playerItem: self.audioplayerItem)
            self.player?.play()
            setupLockScreen()

        }
    }
    
    /* Function Related to Slider */
    
    @objc func updateSliderValue(){
        
        let duration = CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!)
        let currentTime =  CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
        
        DispatchQueue.main.async {
            self.slider.minimumValue = 0
            self.slider.maximumValue = Float(duration)
            self.slider.setValue(Float(currentTime), animated: true)
            
            let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: Int(currentTime))
            self.durationLbl.text = "\(m):\(s)"
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    

    
}
