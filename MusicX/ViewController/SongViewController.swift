//
//  SongViewController.swift
//  MusicX
//
//  Created by Nayef on 3/10/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import AVFoundation

class SongViewController: UIViewController {
    
    /* IBOutlets */
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var NameOfAudio: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var slider: Slider!
    
    /*  Variables Related to PlayListVC */
    var stringURls = [String]()
    var names = [String]()
    var audioArray = [String]()
    var indexCell : Int = 0 ;
    
    /* Global Variables */
    var audioplayerItem : AVPlayerItem!
    var player : AVPlayer?
    
    // var mytimer = Timer()
    var updater : CADisplayLink! = nil
    
    var imageString = String()
    var name = String()
    var audioString = String()
    
    var isPlaying : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageString = stringURls[indexCell]
        name = names[indexCell]
        audioString = audioArray[indexCell]

        songImageView.sd_setImage(with: URL(string: imageString))
        NameOfAudio.text = name
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
    
    
    @IBAction func sliderAction(_ sender: Any) {
        let seconds : Int64 = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        player!.seek(to: targetTime)
    }
    
    
    
     /* Functions */

    func startPlaying() {
        let audioURL = URL(string: audioString)
        self.audioplayerItem =  AVPlayerItem(url: audioURL!)
        self.player = AVPlayer(playerItem: self.audioplayerItem)
        self.player?.play()
    }
    
    /* Function Related to Slider */
    
    @objc func updateSliderValue(){
        
        let duration = CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!)
        let currentTime = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
        
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
