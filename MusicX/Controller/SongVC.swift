//
//  SongVC.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 2/3/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class SongVC: UIViewController {
    
    //    var adioPlayer = AVAudioPlayer()
    var audioplayerItem : AVPlayerItem!
    var player : AVPlayer?
    let realm = try! Realm()
    var locationURL = String().self
    var destinationURLString = String()
    var songs : Results<RealmData>!    
    var songID = 0
    
    //  @IBOutlet weak var audioView: DrawWaveForm!
    
    
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameOfSong: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    // @IBOutlet weak var audioView: AudioVisualizationView!
    
    var stringURls = [String]()
    var names = [String]()
    var audioArray = [String]()
    var index : Int = 0
    var ArrayOfData : Dictionary<String,Data> = [:]
    var ArrayOfUrlChecking = [URL]()
    
    var mytimer = Timer()
    
    var imageUrl = String()
    var name = String()
    var audioString = String()
    
    var isPlaying : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUrl = stringURls[index]
        name = names[index]
        audioString = audioArray[index]
       // imgView.loadGif(name: "Play-1")
        
       imgView.sd_setImage(with: URL(string: imageUrl))
        nameOfSong.text = name
        
        loadSongs()
        
    }
    
    // cache each data that is playing
    func getSongFromTheNetwork(completed: @escaping (Bool) ->Void ) {
        
        let audioURL1 = URL(string: self.audioArray[self.index])
        if !self.ArrayOfUrlChecking.contains(audioURL1!){
            self.ArrayOfUrlChecking.append(audioURL1!)
            DispatchQueue.main.async {
                
                URLSession.shared.dataTask(with: audioURL1!, completionHandler: { (data, urlResponse, error) in
                    if error != nil {
                        print("error while getting songs from the network")
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
        
        
        // you can create function to get nameOfSong
//        var nameOfFile = " "
//        for songTemp in songs {
//            if songTemp.songID == index{
//
//                nameOfFile = songTemp.nameOfFile
//                print("\(nameOfFile) IIIIII")
//                break
        //            }
        //        }
        //
        //        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //        let destinationUrl = documentsDirectoryURL.appendingPathComponent((nameOfFile))
        
        
        let audioURL = URL(string: audioString)
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent((audioURL?.lastPathComponent)!)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists and it will play without network")
            self.audioplayerItem =  AVPlayerItem(url: destinationUrl)
            self.player = AVPlayer(playerItem: self.audioplayerItem)
            self.player?.play()
        } else {
            let audioURL = URL(string: audioString)
            self.audioplayerItem =  AVPlayerItem(url: audioURL!)
            self.player = AVPlayer(playerItem: self.audioplayerItem)
            self.player?.play()
        }
        
//        self.audioplayerItem =  AVPlayerItem(url: audioURL1)
//        self.player = AVPlayer(playerItem: self.audioplayerItem)
//        self.player?.play()
        
        
        
        
    }
    
    
    func getSongPath() -> String{
        var songPath = " "
        for songTemp in songs {
            if songTemp.songID == index{
                
                songPath = songTemp.index
                print("\(songPath) IIIIII")
                break
            }
            
        }
        
        //        let song = RealmData()
        //        do {
        //            try realm.write {
        //
        //            }
        //        } catch {
        //            print(" can't get songs path")
        //        }
        return songPath
    }
    
    
    
    @IBAction func slider(_ sender: Any) {
        let seconds : Int64 = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        player!.seek(to: targetTime)
    }
    
    
    @objc func updateSliderValue(){
        
        let duration = CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!)
        let currentTime = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
        
        DispatchQueue.main.async {
            self.slider.minimumValue = 0
            self.slider.maximumValue = Float(duration)
            self.slider.value = Float(currentTime)
            let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: Int(currentTime))
            self.timeLbl.text = "\(m):\(s)"
        }
        
        
        
        
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    func StartTimer(){
        DispatchQueue.main.async {
            self.mytimer =   Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SongVC.updateSliderValue), userInfo: nil, repeats: true)
            self.mytimer.fire()
            self.updateSliderValue()
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
    
    func saveTODisk(audioString : String) {
        let audioURL = URL(string: audioString)
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent((audioURL?.lastPathComponent)!)
        
        locationURL = destinationUrl.path
        destinationURLString = destinationUrl.absoluteString
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
        } else {
            URLSession.shared.downloadTask(with: audioURL!, completionHandler: { (location, responce, error) in
                if error == nil {
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location!, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                }
            }).resume()
        }
    }
    
    func deleteFilesFromDirectory(){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let dirFile = paths[0]
        
        // let name = songs?[index].nameOfSong ?? print("can't deletate")
        var nameOfFile = "" 
        for songTemp in songs {
            if songTemp.songID == index{
                
                nameOfFile = songTemp.nameOfFile
                print(songTemp.nameOfFile)
                break
            }
        }
        
        let filePath = "\(dirFile)/\(nameOfFile)"
        if FileManager.default.fileExists(atPath: filePath)
        {
            print("File Exisit")
            do {
                try  FileManager.default.removeItem(atPath: filePath)
                print("File is removed")
            } catch {
                print(error)
            }
            
        } else {
            print("File does not exist")
        }
    }
    
    
    func loadSongs(){
        
        songs = realm.objects(RealmData.self)
        print(songs)
    }
    
    
    
    
    
    // MARK : - Button Actions
    
    @IBAction func backBtn(_ sender: Any) {
        if player?.rate != 0 {
            self.player?.pause()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func leftBtn(_ sender: Any) {
        if index > 0{
            if player?.rate != 0 {
                self.player?.pause()
            }
            self.index = self.index - 1
            updateSongVC(index: self.index)
            //    getSongFromTheNetwork(completed: { (success) in
            //       if success {
            self.playSongFunc()
            self.StartTimer()
            //        }
            //      })
            
        }
    }
    
    @IBOutlet weak var platSingBtn: UIButton!
    @IBAction func playSong(_ sender: Any) {
        if isPlaying == false {
            self.platSingBtn.setImage(UIImage(named: "ic_pause_48px"), for: UIControlState.normal)
            
            self.playSongFunc()
            self.StartTimer()

            isPlaying = true
        } else {
            self.platSingBtn.setImage(UIImage(named: "ic_play_arrow_48px"), for: UIControlState.normal)
            self.player?.pause()
            isPlaying = false
        }
    }
    
    
    @IBAction func rightBtn(_ sender: Any) {
        if index + 1 <= stringURls.count{
            if self.isPlaying {
                self.player?.pause()
            }
            self.index = self.index + 1
            updateSongVC(index: self.index)
            
            //   getSongFromTheNetwork(completed: { (success) in
            //  if success {
            self.playSongFunc()
            self.StartTimer()
            //       }
            //   })
            
        }
    }
    
    @IBAction func saveSongBtn(_ sender: Any) {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        saveTODisk(audioString: audioString)
        songID = index
        let song = RealmData()
        do {
            
            song.nameOfSong = names[index]
            song.index = destinationURLString
            song.songID = songID
            let fileName = (locationURL as NSString).lastPathComponent
            song.nameOfFile = fileName
            var exsist = false
            try realm.write {
                for songTemp in songs {
                    if songTemp.nameOfSong == song.nameOfSong {
                        print("song exist")
                        exsist = true
                        break
                    }
                }
                if !exsist {
                    self.realm.add(song)
                } else {
                    print("Song alrady saved in Realm")
                }
            }
        }catch
        {
            print("error saving data to realm")
        }
        
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        deleteFilesFromDirectory()
        do {
            try realm.write {
                for songTemp in songs {
                    if songTemp.songID == index{
                        print("deleteing song from Realm ")
                        realm.delete(songTemp)
                        break
                    }
                }
                
                
            }
        } catch {
            print("error deleting object from Realm")
        }
    }
    
    
    
    
    
}
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



/////////////////////////////////////////////////////////////////////////////////////////////////
//
//                    self.audioView.meteringLevelBarWidth = 2.0
//                    self.audioView.meteringLevelBarInterItem = 1.0
//                    self.audioView.meteringLevelBarCornerRadius = 5.0
//                    self.audioView.audioVisualizationMode = .read
//                    self.audioView.meteringLevelsArray = [0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43 ,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43,0.4, 0.1, 0.4, 0.2, 0.5, 0.6, 0.1, 0.0, 0.6, 0.43 ]
//
//    self.audioView.play(for: self.audioPlayer.duration)
// self.audioView.addMeteringLevel(Float(self.audioPlayer.currentTime/self.audioPlayer.duration))



//                DispatchQueue.main.async {
//
//                    let audioUrl3 = URL(string:self.audioUrl)
//                    //let url =  URL.init(fileURLWithPath: Bundle.main.path(forResource: "a", ofType: "mp3")!)
//                    do {
//                        let myAudioFile = try AVAudioFile(forReading: audioUrl3!)
//                        let myAudioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: myAudioFile.fileFormat.sampleRate, channels: myAudioFile.fileFormat.channelCount, interleaved: false)//Format of the file
//
//                        //   let myAudioFrameCount = UInt32(myAudioFile.length)
//                        let myAudioBuffer = AVAudioPCMBuffer(pcmFormat: myAudioFormat!, frameCapacity: UInt32(myAudioFile.length))
//                        try! myAudioFile.read(into: myAudioBuffer!)
//                        ReadFile.arrayFloatValues = Array(UnsafeBufferPointer(start: myAudioBuffer?.floatChannelData?[0], count:Int(String(describing: myAudioBuffer?.frameLength))!))
//
//
//                    } catch {
//                        print(error)
//                    }
//
//                }

//    @objc func updateViewProgress(){
//
//        DispatchQueue.main.async {
//            let time = Float(self.audioPlayer.currentTime/self.audioPlayer.duration)
//            self.progressView.setProgress(time, animated: true)
//            self.timeLbl.text = "\(Int(self.audioPlayer.currentTime))"
//            NSLog("Hi I am ViewProgress")
//        }
//
//    }


//    func getSong(url : String) -> AVAudioPlayer {
//        let audioUrl = URL(string: url)
//        do {
//            let dataUrl = try Data(contentsOf: audioUrl!)
//            self.audioPlayer = try AVAudioPlayer(data: dataUrl)
//        } catch {
//            print(error)
//        }
//        return audioPlayer
//    }

//
//    func getImage(imageURL : String?) -> Data {
//        let url = URL(string: imageUrl)
//        do {
//            let data = try Data(contentsOf: url!)
//            return data
//        } catch {
//            print(error)
//        }
//        return Data()
//    }

//  let url = URL(string: audioArray[index])
// song.songsData = try Data(contentsOf: url!)


//
//func playSongFunc(){
//
//    //  if  let dataAudio = ArrayOfData["\(self.index)"] {
//    //        let songPath = getSongPath()
//    //        //let url = URL.init(fileURLWithPath: songPath)
//    //        let url1 :URL = Bundle.main.url(forResource: "mishary-rashid-alafasy-001-al-fatiha-30-7477", withExtension: "mp3")!
//    //        print(url1)
//    //            //URL(fileURLWithPath: songPath)
//    //        let url = URL(fileURLWithPath: "file:///Users/Nayef/Library/Developer/CoreSimulator/Devices/CAE37049-7FFC-45B8-9E47-E16FD5482C91/data/Containers/Bundle/Application/C93A53B2-51D4-4DF3-9F3F-592E924D2947/MusicX.app/mishary-rashid-alafasy-001-al-fatiha-30-7477.mp3")
//    //        let assest = AVAsset(url: url)
//    //        //let url = URL(string: audioArray[self.index])
//    ////        self.audioplayerItem =  AVPlayerItem(url: url )
//    //
//    let audioURL1 = URL(string: audioUrl)
//    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let destinationUrl = documentsDirectoryURL.appendingPathComponent((audioURL1?.lastPathComponent)!)
//
//    self.audioplayerItem =  AVPlayerItem(url: destinationUrl)
//    self.player = AVPlayer(playerItem: self.audioplayerItem)
//    self.player?.play()
//
//
//
//
//}

