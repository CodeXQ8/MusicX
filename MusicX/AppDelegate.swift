//
//  AppDelegate.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 1/22/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
//import Firebase
import RealmSwift
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      //  FirebaseApp.configure()
        do {
            _ = try Realm()
        } catch {
            print("error create Realm \(error)")
        }
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//        becomeFirstResponder()
//        setupAudioSession()
     
        return true
    }
    
    //Then in your UIResponder (or your AppDelegate if you will)
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
           // player.remoteControlReceivedWithEvent(event)
        }
    }

    func setupAudioSession(){
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)

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
    
//    override func remoteControlReceived(with event: UIEvent?) {
//        if (event?.type == .remoteControl) {
//            //            NotificationCenter.default.post(NSNotification)
//            //            (name: NSNotification.Name(rawValue: Configure.remotePlayCotrolNotificaation), object: nil, userInfo: ["event":event!])
//        }
//    }
    
    
    
    
}

