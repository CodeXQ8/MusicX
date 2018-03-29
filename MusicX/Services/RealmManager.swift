//
//  RealmManager.swift
//  MusicX
//
//  Created by Nayef Alotaibi on 3/11/18.
//  Copyright © 2018 Nayef Alotaibi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    let realm = try! Realm()
    var reciters : Results<Reciters>?
    
    var surahs : Results<ReciterSurahs>?
    
    static let sharedInstance = RealmManager()

     func saveToRealmReciter(reciter : Reciters) {
        do {
                try realm.write {
                    realm.add(reciter)
                    print("reciter saved")
                }
        } catch
        {
            print("Can't save reciter to Realm")
        }
    }
    
    func loadRecitersFromRealm() -> Results<Reciters> {
        reciters = realm.objects(Reciters.self)
        return reciters!
    }
    
    func loadSurahsFromRealm(reciter: Reciters) -> Results<ReciterSurahs> {
        surahs = reciter.reciterSurahs.sorted(byKeyPath: "surahName", ascending: true)
        return surahs!
    }
    
    
    func checkIfFileExist(reciter : Reciters,reciters: Results<Reciters>?, exist : @escaping (Bool) ->() ) {

        if reciters != nil {
            for reciterTemp in reciters! {
                if reciterTemp.reciterName == reciter.reciterName {
                    exist(true)
                    return
                }
            }
        }
        exist(false)
        
    }



}



