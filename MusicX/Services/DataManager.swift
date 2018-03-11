//
//  DataManger.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 2/17/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit


class DataManager{
    
//    func saveTODisk(audioString : String) {
//        let audioURL = URL(string: audioString)
//        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let destinationUrl = documentsDirectoryURL.appendingPathComponent((audioURL?.lastPathComponent)!)
//        
//       var locationURL = destinationUrl.path
//        destinationURLString = destinationUrl.absoluteString
//        if FileManager.default.fileExists(atPath: destinationUrl.path) {
//            print("The file already exists at path")
//        } else {
//            URLSession.shared.downloadTask(with: audioURL!, completionHandler: { (location, responce, error) in
//                if error == nil {
//                    do {
//                        // after downloading your file you need to move it to your destination url
//                        try FileManager.default.moveItem(at: location!, to: destinationUrl)
//                        print("File moved to documents folder")
//                    } catch let error as NSError {
//                        print(error.localizedDescription)
//                    }
//                    
//                }
//            }).resume()
//        }
//    }
//    
//    
//    func deleteFilesFromDirectory(songs : Results<RealmData> , indexCell: Int){
//        let dirFile = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
//       
//        var nameOfFile = ""
//        for songTemp in songs {
//            if songTemp.songID == indexCell {
//                nameOfFile = songTemp.nameOfFile
//                print(songTemp.nameOfFile)
//                break
//            }
//        }
//        
//        let filePath = "\(dirFile)/\(nameOfFile)"
//        if FileManager.default.fileExists(atPath: filePath)
//        {
//            print("File Exisit")
//            do {
//                try  FileManager.default.removeItem(atPath: filePath)
//                print("File is removed")
//            } catch {
//                print(error)
//            }
//            
//        } else {
//            print("File does not exist")
//        }
//    }
    
}
