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
        
        customRecord[remoteAttributes.lineName] = lineName
        customRecord[remoteAttributes.linePassword] = linePassword
        customRecord[remoteAttributes.stationNames] = stationNames
        customRecord[remoteAttributes.lineOwner] = tokenReference
        cloudDB.share.publicDB.save(customRecord, completionHandler: ({returnRecord, error in
            if error != nil {
                
                print("saveLine error \(error)")
            } else {
                let defaults = UserDefaults.standard
                defaults.set(lineName, forKey: remoteAttributes.lineName)
                defaults.set(linePassword, forKey: remoteAttributes.linePassword)
                defaults.set(stationNames, forKey: remoteAttributes.stationNames)
                linesRead.append(lineName)
                linesGood2Go = !linesGood2Go
                let peru = Notification.Name("confirmPin")
                NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
                print("didSet")
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
    
    var tokenReference: CKReference!
    
    public func saveToken(token2Save: String) {
        
        let customRecord = CKRecord(recordType: remoteRecords.devicesLogged)
        customRecord[remoteAttributes.deviceRegistered] = token2Save
        cloudDB.share.publicDB.save(customRecord, completionHandler: ({returnRecord, error in
            if error != nil {
                
                print("saveLine error \(error)")
            } else {
                let tokenReference = CKReference(record: customRecord, action: CKReferenceAction.none)
            }
        }))
    }
    
    public func updateLine(lineName: String, stationNames:[String], linePassword:String) {
//        let predicate = NSPredicate(value: true)
        let predicate = NSPredicate(format: remoteAttributes.lineName + " = %@", lineName)
        let query = CKQuery(recordType: remoteRecords.notificationLine, predicate: predicate)
        cloudDB.share.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                if records?.count == 0 {
                    self.saveLine(lineName: lineName, stationNames: stationNames, linePassword: linePassword)
                } else {
                    // Modify record
                }
            }
        }
    
    }
    
    public func returnAllLines() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: remoteRecords.notificationLine, predicate: predicate)
        cloudDB.share.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                for record in records! {
                    linesRead.append(record[remoteAttributes.lineName]!)
                    linesDictionary[remoteAttributes.lineName] = record[remoteAttributes.linePassword]
                }
                linesGood2Go = !linesGood2Go
                print("linesRead read \(linesRead)")
            }
        }
    }
    
    public func returnStationsOnLine(line2Seek: String) {
        let predicate = NSPredicate(format: remoteAttributes.lineName + " = %@", line2Seek)
        let query = CKQuery(recordType: remoteRecords.notificationLine, predicate: predicate)
        cloudDB.share.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if records!.count > 0 {
                    let stationsFound = records!.first!.object(forKey: remoteAttributes.stationNames)
                    //                    syntax that crashes !!
                    //                        let stationsFound = records!.first![remoteAttributes.stationNames]! as? [String]
                    if (stationsFound as? [String])!.count > 0 {
                        stationsRead = (stationsFound as? [String])!
                        stationsGood2Go = !stationsGood2Go
                    }
                    self.returnTokenWithID(record: records!.first!.object(forKey: remoteAttributes.lineOwner) as? CKReference)
                }
            }
        }
    }
    
    public func returnTokenWithID(record: CKReference?) {
        cloudDB.share.publicDB.fetch(withRecordID: (record?.recordID)!) { (record, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let tokenDiscovered = record!.object(forKey: remoteAttributes.deviceRegistered) as? String
                if ownerToken == tokenDiscovered {
                    let peru = Notification.Name("enablePost")
                    NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
                } else {
                    let peru = Notification.Name("disablePost")
                    NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
                }
                
            }
        }
    }
    
    public func updateToken(token2Save: String) {
        let predicate = NSPredicate(format: remoteAttributes.deviceRegistered + " = %@", token2Save)
        let query = CKQuery(recordType: remoteRecords.devicesLogged, predicate: predicate)
        cloudDB.share.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                if records?.count == 0 {
                    self.saveToken(token2Save: token2Save)
                } else {
                    // update record
                }
            }
            
        }
    }
    
    
    
    public func returnAllTokens() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: remoteRecords.devicesLogged, predicate: predicate)
        cloudDB.share.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                for record in records! {
                    tokensRead.append(record[remoteAttributes.deviceRegistered]!)
                }
                print("tokens read \(tokensRead)")
            }
        }
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


