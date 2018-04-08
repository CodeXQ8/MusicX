//
//  SurahAPI.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 4/7/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation

struct SurahAPI {
    let name : String
    let englishName : String
    let ayahs : [Any]
    
    
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        
        guard let name = json["name"] as? String else {throw SerializationError.missing("name is missing")}
        guard let englishName = json["englishName"] as? String else {throw SerializationError.missing("englishName is missing")}
        guard let ayahs = json["ayahs"] as? [Any] else {throw SerializationError.missing("ayahs is missing")}
        
        self.name = name
        self.englishName = englishName
        self.ayahs = ayahs
    }
    
    
    static let basePath = "https://api.alquran.cloud/quran/ar.alafasy"
    
    static func getSurahs (completion: @escaping ([SurahAPI]) -> ()) {
        
        let url = basePath
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var surahArray:[SurahAPI] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let data = json["data"] as? [String:Any] {
                           // print(data)
                            if let surahs = data["surahs"] as? [[String:Any]] {
                          //       print(surahs)
                              if let surah = surahs[0] as? [String:Any] {
                             //    print(surah)
                               // for surah in surahs {
                                     // print(surahs)
                                    if let surahObject = try? SurahAPI(json: surah) {
                                           print(surahObject)
                                        surahArray.append(surahObject)
                                    }
                               // }
                                }
                                
                            }
                        }
                    }
                    
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(surahArray)
                
            }
        }
        task.resume()
    }
}


