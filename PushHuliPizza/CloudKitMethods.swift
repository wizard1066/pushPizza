//
//  CloudKitMethods.swift
//  PushHuliPizza
//
//  Created by localadmin on 14.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class cloudDB: NSObject {
    
static let share = cloudDB()

var publicDB:CKDatabase!
var privateDB: CKDatabase!
var sharedDB: CKDatabase!

    private override init() {
        let container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
    }
    
    public func saveZone(zone2U: String) {
        let customZone = CKRecordZone(zoneName: zone2U)
        
//        cloudDB.share.privateDB.save(customZone, completionHandler: ({returnRecord, error in
//            if error != nil {
//                print("\(error!.localizedDescription)")
//            } else {
//                print("customZoneID \(customZone.zoneID)")
//            }
//
//        }))
        
        let operation = CKModifyRecordZonesOperation(recordZonesToSave: [customZone], recordZoneIDsToDelete: nil)
        operation.modifyRecordZonesCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if error != nil {
                print("\(error!.localizedDescription)")
            } else {
                print("customZoneID \(customZone.zoneID)")
                self.saveShare(lineName: zone2U, zoneID: customZone.zoneID)
            }
        }
//        cloudDB.share.privateDB.add(operation)
        CKContainer.default().privateCloudDatabase.add(operation)
    }
    
    var parentRecord: CKRecord!
    
    public func saveShare(lineName: String, zoneID: CKRecordZoneID) {
        parentRecord = CKRecord(recordType: remoteRecords.notificationShare, zoneID: zoneID)
        parentRecord[remoteAttributes.lineName] = lineName
        parentRecord[remoteAttributes.stationNames] = ["default"]
        let share = CKShare(rootRecord: parentRecord)
        share[CKShareTitleKey] = "Shared Parent" as CKRecordValue
        
        let saveOperation = CKModifyRecordsOperation(recordsToSave: [parentRecord, share], recordIDsToDelete: nil)
        // could also use phone or cloudkit user record ID
        let search = CKUserIdentityLookupInfo.init(emailAddress: "mona.lucking@gmail.com")
        let person2ShareWith = CKFetchShareParticipantsOperation(userIdentityLookupInfos: [search])
        person2ShareWith.fetchShareParticipantsCompletionBlock = { error in
            if error != nil {
                print("fetchShareParticipantsCompletionBlock \(error)")
            }
        }
        person2ShareWith.shareParticipantFetchedBlock = {participant in
            print("participant \(participant)")
            participant.permission = CKShareParticipantPermission.readOnly
            
            share.addParticipant(participant)
            
            let modifyOperation: CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [self.parentRecord, share], recordIDsToDelete: nil)
            
            modifyOperation.savePolicy = .ifServerRecordUnchanged
            modifyOperation.perRecordCompletionBlock = {record, error in
                print("record completion \(record) and \(error)")
            }
            modifyOperation.modifyRecordsCompletionBlock = {records, recordIDs, error in
                guard let ckrecords: [CKRecord] = records, let record: CKRecord = ckrecords.first, error == nil else {
                    print("error in modifying the records " + error!.localizedDescription)
                    return
                }
                print("share url \(share.url) \(share.participants)")
                url2Share = share.url?.absoluteString
                let peru = Notification.Name("sharePin")
                NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
                self.saveImage2Share(zone2U: zoneID)
//                let metadataOperation = CKFetchShareMetadataOperation.init(share: [share.url!])
//                metadataOperation.perShareMetadataBlock = {url, metadata, error in
//                    print("record completion \(url) \(metadata) \(error)")
//                    let acceptShareOperation = CKAcceptSharesOperation(shareMetadatas: [metadata!])
//                    acceptShareOperation.qualityOfService = .background
//                    acceptShareOperation.perShareCompletionBlock = {meta, share, error in
//                        print("meta \(meta) share \(share) error \(error)")
//                    }
//                    acceptShareOperation.acceptSharesCompletionBlock = {error in
//                        print("error in accept share completion \(error)")
//                        /// Send your user to wear that need to go in your app
//
//                    }
//                    CKContainer.default().add(acceptShareOperation)
//                    self.saveImage2Share(zone2U: zoneID)
//                }
//                metadataOperation.fetchShareMetadataCompletionBlock = { error in
//                    if error != nil {
//                        print("metadata error \(error!.localizedDescription)")
//                    }
//                }
//                CKContainer.default().add(metadataOperation)
            }
            cloudDB.share.privateDB.add(modifyOperation)
        }
        CKContainer.default().add(person2ShareWith)
    }
    
    public func saveImage2Share(zone2U: CKRecordZoneID) {
        let customRecord = CKRecord(recordType: remoteRecords.notificationMedia, zoneID: zone2U)
        let fileURL = Bundle.main.bundleURL.appendingPathComponent("Marley.png")
        let ckAsset = CKAsset(fileURL: fileURL)
        customRecord[remoteAttributes.mediaFile] = ckAsset
        customRecord.setParent(parentRecord)
        cloudDB.share.privateDB.save(customRecord, completionHandler: ({returnRecord, error in
            if error != nil {
                
                print("saveLine error \(error)")
            } else {
                print("Marley banked")
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
//                linesGood2Go = !linesGood2Go
                let peru = Notification.Name("confirmPin")
                NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
                print("didSet")
                self.saveZone(zone2U: lineName)
            }
        }))
    }
    
    public func deleteLine(lineName: String, linePassword: String) {
        let recordID2Access = linesDictionary[lineName + linePassword]
        cloudDB.share.publicDB.delete(withRecordID: recordID2Access!) { (recordID, error) in
            guard let recordID = recordID else {
                print(error!.localizedDescription)
                return
            }
            print("Record \(recordID) was successfully deleted")
        }
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
                    linesDictionary[record[remoteAttributes.lineName]! + record[remoteAttributes.linePassword]!] = record.recordID
                }
                let peru = Notification.Name("showPin")
                NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
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
                        let peru = Notification.Name("stationPin")
                        NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
                    }
                    self.returnTokenWithID(record: records!.first!.object(forKey: remoteAttributes.lineOwner) as? CKReference)
                }
            }
        }
    }
    
    public func returnTokenWithID(record: CKReference?) {
        if record == nil { return }
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


