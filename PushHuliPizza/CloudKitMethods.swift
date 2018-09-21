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
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
    }
    
    public func createLine(lineName: String, stationNames:[String], linePassword:String) {
        let customZone = CKRecordZone(zoneName: lineName)
        cloudDB.share.publicDB.save(customZone, completionHandler: ({returnRecord, error in
            if error != nil {
//                OperationQueue.main.addOperation {
////                self.textView.text = "Cloud Error\n\(error.localizedDescription)"
//                }
                print("saveLine error \(error)")
            } else {
                
//                OperationQueue.main.addOperation {
////                self.textView.text = "The 'FriendsZone' was successfully created in the private database."
//                }
            }
        }))

    }
    
    public func saveLine(lineName: String, stationNames:[String], linePassword:String) {
        let customRecord = CKRecord(recordType: remoteRecords.notificationLine)
        customRecord[remoteRecords.lineName] = lineName
        customRecord[remoteRecords.linePassword] = linePassword
        customRecord[remoteRecords.stationNames] = stationNames
        cloudDB.share.publicDB.save(customRecord, completionHandler: ({returnRecord, error in
            if error != nil {
                
                print("saveLine error \(error)")
            } else {
                let defaults = UserDefaults.standard
                defaults.set(lineName, forKey: remoteRecords.lineName)
                defaults.set(linePassword, forKey: remoteRecords.linePassword)
                defaults.set(stationNames, forKey: remoteRecords.stationNames)
                
            }
        }))
    }
    
    public func deleteLine(lineName: String, linePassword: String) {
        
    }
    
    public func modifyStations(lineName: String, stationName: String) {
        
    }
    
    public func readLines() -> [String] {
        var linesRead:[String]!
        return linesRead
    }
    
    public func saveToken(token2Save: String) {
        print("token2Save \(token2Save)")
        let customRecord = CKRecord(recordType: remoteRecords.devicesLogged)
        customRecord[remoteRecords.lineName] = token2Save
        cloudDB.share.publicDB.save(customRecord, completionHandler: ({returnRecord, error in
            if error != nil {
                
                print("saveLine error \(error)")
            } else {
                
                
            }
        }))
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


