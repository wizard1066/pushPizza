//
//  CloudKitMethods.swift
//  PushHuliPizza
//
//  Created by localadmin on 14.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import Foundation
import CloudKit

class cloudDB {
    
static let share = cloudDB()

var publicDB:CKDatabase!
var privateDB: CKDatabase!
var sharedDB: CKDatabase!

    private init() {
        let container = CKContainer.default()
        let publicDB = container.publicCloudDatabase
        let privateDB = container.privateCloudDatabase
        let sharedDB = container.sharedCloudDatabase
    }

}


//var keyStore = NSUbiquitousKeyValueStore()

//func icloudStatus() -> Bool?{
//    return FileManager.default.ubiquityIdentityToken != nil ? true : false
//}
//
//func returnURLgivenKey(key2search: String, typeOf: String) -> String? {
//    let searchString2U = key2search.trimmingCharacters(in: .whitespacesAndNewlines) + typeOf
//    if let storedURL = keyStore.string(forKey: searchString2U) {
//        return storedURL
//    } else {
//        return nil
//    }
//}
//
//func storeURLgivenKey(key2Store: String, URL2Store: String, pass2U: String) {
//    let URLkey2U = key2Store.trimmingCharacters(in: .whitespacesAndNewlines) + ".URL"
//    let passKey2U = key2Store.trimmingCharacters(in: .whitespacesAndNewlines) + ".PASS"
//    keyStore.set(URL2Store, forKey: URLkey2U)
//    keyStore.set(pass2U, forKey: passKey2U)
//    keyStore.synchronize()
//}


