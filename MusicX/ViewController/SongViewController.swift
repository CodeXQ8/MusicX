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
import NVActivityIndicatorView

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
    //var audioString = String()
    
    var isPlaying : Bool = false
    
    var elapsedTime = Double()

    override func viewDidDisappear(_ animated: Bool) {
//        MPRemoteCommandCentercommandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//        [commandCenter.nextTrackCommand removeTarget:self];
//        [commandCenter.previousTrackCommand removeTarget:self];
     //   MPRemoteCommandCenter.shared().nextTrackCommand.removeTarget(self)
    }
    
  
    var nowPlayingInfo = [String : Any]()
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSongs()
        
        imageString = songs[indexCell].stringURl
        name = songs[indexCell].names
        // audioString = songs[indexCell].audioUrl
        
        songImageView.sd_setImage(with: URL(string: imageString))
        NameOfAudio.text = name
        
    }
    
    /* IBActions */
    
    @IBAction func BackBtnWasPressed(_ sender: Any) {
        if player?.rate != 0 {
            self.player?.pause()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightBtnWasPressed(_ sender: Any) {
        nextSong()
    }
    
    @IBAction func leftBtnWasPressed(_ sender: Any) {
        previousSong()
    }
    
    
    @IBOutlet weak var playBtnOutLet: UIButton!
    @IBAction func playBtnWasPressed(_ sender: Any) {
        if isPlaying == false {
            DispatchQueue.main.async() {
                self.playBtnOutLet.setImage(UIImage(named: "ic_pause_48px"), for: UIControlState.normal)
                self.startPlaying()
                self.activityIndicatorView.startAnimating()
                self.updater = CADisplayLink(target: self, selector: #selector(SongViewController.updateSliderValue))   // Updating Slider Using CADisplay
                self.updater.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            }
            isPlaying = true
           
         
        } else {
            DispatchQueue.main.async() {
                self.playBtnOutLet.setImage(UIImage(named: "ic_play_arrow_48px"), for: UIControlState.normal)
                self.activityIndicatorView.stopAnimating()
            }
            player?.pause()
            isPlaying = false
        }
        
        
    }
    
    
    /*  AudioPlayer Lock Control */
    
    func updateLockScreen(){
        
        let image = UIImage(named: "1")!
        let songImage = MPMediaItemArtwork.init(boundsSize: image.size) { (size) -> UIImage in
            return image
        }
        nowPlayingInfo[MPMediaItemPropertyTitle] = songs[indexCell].names
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentItem?.currentTime().seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        nowPlayingInfo[MPMediaItemPropertyArtwork] = songImage
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
   
    }

    
    func lockScreenCommands() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            if self.player?.rate == 0.0 {
                self.player?.play()
                return .success
            }
            return .commandFailed
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            if self.player?.rate != 0.0 {
                self.player?.pause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.nextSong()
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.previousSong()
            return .success
        }
        
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        if player != nil {
            player?.pause()
            let seconds : Int64 = Int64(slider.value)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            player!.seek(to: targetTime)
          
            slider.addTarget(self, action: #selector(sliderStopChainging), for: .touchUpInside)
        }
    }
    
    @objc func sliderStopChainging(){
        updateLockScreen()
        player?.play()
    }
    /* Functions for AVPlayer */
    
    func startPlaying() {
        
        let audioURL = URL(string: songs[indexCell].audioUrl)
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent((audioURL?.lastPathComponent)!)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists and it will play without network")
           // let asset = AVAsset(url: destinationUrl)
            self.audioplayerItem =  AVPlayerItem(url: destinationUrl)
            NotificationCenter.default.addObserver(self, selector: #selector(nextSong), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioplayerItem)
            self.player = AVPlayer(playerItem: self.audioplayerItem)
            self.player?.play()
            updateLockScreen()
            lockScreenCommands()
    
        } else {
            print("The song  will play with network")
            //let asset = AVAsset(url: audioURL!)
            self.audioplayerItem =  AVPlayerItem(url: audioURL!)
            NotificationCenter.default.addObserver(self, selector: #selector(nextSong), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioplayerItem)
            self.player = AVPlayer(playerItem: self.audioplayerItem)
            self.player?.play()
            updateLockScreen()
            lockScreenCommands()
        }
    }
    
    
    @objc func nextSong(){
        if indexCell + 1 < songs.count{
            if player?.rate != 0 {
                self.player?.pause()
            }
            indexCell = indexCell + 1
            updateSongVC()
            startPlaying()
        }
    }
    
    func previousSong(){
        if indexCell > 0 {
            if player?.rate != 0 {
                self.player?.pause()
            }
            indexCell = indexCell - 1
            updateSongVC()
            startPlaying()
        }
    }
    
    func updateSongVC()
    {
        self.NameOfAudio.text = songs?[indexCell].names
        let imageUrl = songs?[indexCell].stringURl
        self.songImageView.sd_setImage(with:URL(string: imageUrl!) )
        
    }
    
    
    /* Function Related to Slider */
    
    @objc func updateSliderValue(){
        
        let duration = CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!)
        let currentTime =  CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)

        DispatchQueue.main.async {
            self.slider.minimumValue = 0
            self.slider.maximumValue = Float(duration)
            self.slider.setValue(Float(currentTime), animated: true)
            self.durationLbl.text = self.secondsToHoursMinutesSeconds(currentTime)
        }
        if player?.rate == Float(duration){
            nextSong()
        }
    }
    
    func secondsToHoursMinutesSeconds (_ timeInterval: TimeInterval) -> String {
        let timeInt = Int(round(timeInterval))
        let (h, m, s) = (timeInt / 3600, (timeInt % 3600) / 60, (timeInt % 3600) % 60)
        let hour: String? = h > 0 ? String(h) : nil
        let minute = (h > 0 && m < 10 ? "0" : "") + String(m)
        let second = (s < 10 ? "0" : "") + String(s)
        return (hour != nil ? (hour! + ":") : "") + minute + ":" + second
    }
    
    
    
    @IBAction func downloadBtnWasPressed(_ sender: Any) {
        
        DataManager().saveTODiskAndGetLocuationString(audioString: songs[indexCell].audioUrl) { (location, success) in
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
    
    
    /* Functions for Realm*/
    
    func saveToRealm(nameOfSong:String, songID:Int) {
        //   print(Realm.Configuration.defaultConfiguration.fileURL)
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
    
}
