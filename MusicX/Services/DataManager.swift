//
//  DataManger.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 2/17/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import UIKit
import SCLAlertView

class DataManager{
    
    var  locationString = ""
    var success = false
    
    func saveTODiskAndGetLocuationString(audioString : String ) -> String {
        let audioURL = URL(string: audioString)
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent((audioURL?.lastPathComponent)!)
        print(destinationUrl.path)
        locationString = destinationUrl.path
        //destinationURLString = destinationUrl.absoluteString
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
        } else {
            URLSession.shared.downloadTask(with: audioURL!, completionHandler: { (location, responce, error) in
                if error == nil {
                    
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location!, to: destinationUrl)
                        self.success = true
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                }
            }).resume()
        }
        if success == true {
         let alertController = SCLAlertView()
            alertController.showSuccess("Download" , subTitle: " Song is downloaded" )

        }
        return locationString
    }
    
    
    func deleteFilesFromDirectory(fileName: String){
        let dirFile = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
        
        let filePath = "\(dirFile)/\(fileName)"
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
    
}
