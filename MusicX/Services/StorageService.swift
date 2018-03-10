//
//  StorageService.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 1/22/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
//import Firebase



 //let SR_BASE = Storage.storage().reference()

class StorageService {
//    static let instance = StorageService()
//
//    private let _REF_AUDIO = SR_BASE.child("Audio")
//    private let _REF_IMG = SR_BASE.child("Image")
//    var i : Int = 0
//    var urls = [URL]()
//
//
//    var REF_AUDIO : StorageReference {
//        return _REF_AUDIO
//    }
//
//    var REF_IMG: StorageReference {
//        return _REF_IMG
//    }
//
//    func uploadImgToStorage(name:String, url: URL){
//        do {
//            let data = try Data(contentsOf: url)
//            REF_IMG.child("\(i)").putData(data, metadata: nil) { (metaData, error) in
//                if error == nil
//                {
//                    if let url = metaData?.downloadURL()?.absoluteString{
//                        DataService.instance.uploadSong(name: "\(self.i)", urlAudio: url, urlImage: url)
//                        print("Image Successfully Uploaded")
//                    }
//                    self.i = self.i + 1
//                } else {
//                    print("There is an error while uploading the image \(String(describing: error))")
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
//
//    func uploadAudioToStorage(name:String, url: URL){
//        do {
//            let data = try Data(contentsOf: url)
//            REF_AUDIO.child("\(i)").putData(data, metadata: nil) { (metaData, error) in
//                if error == nil
//                {
//                    if let url = metaData?.downloadURL()?.absoluteString{
//                        DataService.instance.uploadSong(name: "\(self.i)", urlAudio: url, urlImage: url)
//                        print("Audio Successfully Uploaded")
//                    }
//                    self.i = self.i + 1
//                } else {
//                    print("There is an error while uploading the audio \(String(describing: error))")
//                }
//            }
//        } catch {
//            print(error)
//        }
//
//    }
//
//    func getUrlsWithRetuen ()->[URL] {
//        for i in 1...4 {
//            REF_IMG.child("\(i).jpg").downloadURL { (url, error) in
//                if error != nil {
//                    print(error)
//                }
//                self.urls.append(url!)
//            }
//        }
//        return self.urls
//    }
//
//
//    func getUrls(handler: @escaping (_ urls: [URL]) -> ()) {
//
//        for i in 1...4 {
//
//            REF_IMG.child("\(i).jpg").downloadURL { (url, error) in
//                if error != nil { print(error)}
//                self.urls.append(url!)
//            }
//
//    }
//        print(self.urls.count)
//        handler(self.urls)
//    }
//
}

