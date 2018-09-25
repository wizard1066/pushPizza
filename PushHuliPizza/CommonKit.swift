//
//  CommonKit.swift
//  PushHuliPizza
//
//  Created by localadmin on 21.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

enum segueNames {
    static let posting = "posting"
    static let principle = "principle"
    static let configuration = "configuration"
}

enum remoteRecords {
    static let notificationLine = "notificationLine"
    static let devicesLogged = "devicesLogged"
    static let notificationShare = "notificationShare"
    static let notificationMedia = "notificationMedia"
}

enum remoteAttributes {
    static let stationNames = "stationNames"
    static let linePassword = "linePassword"
    static let lineName = "lineName"
    static let lineOwner = "lineOwner"
//    static let tokenReference = "tokenreference"
    static let deviceRegistered = "deviceRegistered"
    static let mediaFile = "mediaFile"
}

var ownerToken: String!
var tokensRead:[String] = []
var linesRead:[String] = []
var stationsRead:[String] = []
var linesGood2Go: Bool = false
var stationsGood2Go: Bool = false {
    didSet {
        let peru = Notification.Name("stationPin")
        NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
        print("stationPin")
    }
}

var linesDictionary:[String:CKRecordID] = [:]
var controller:UICloudSharingController!
var url2Share: String!
