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
    
    func loadRecitersromRealm() -> Results<Reciters> {
        reciters = realm.objects(Reciters.self)
        return reciters!
    }


}



