//
//  CommonKit.swift
//  PushHuliPizza
//
//  Created by localadmin on 21.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import Foundation

enum segueNames {
    static let posting = "posting"
    static let principle = "principle"
    static let configuration = "configuration"
}

enum remoteRecords {
    static let notificationLine = "notificationLine"
    static let devicesLogged = "devicesLogged"
}

enum remoteAttributes {
    static let stationNames = "stationNames"
    static let linePassword = "linePassword"
    static let lineName = "lineName"
    static let deviceRegistered = "deviceRegistered"
}

var tokensRead:[String] = []
var linesRead:[String] = []
var stationsRead:[String] = []
var linesGood2Go: Bool = false {
    didSet {
        let peru = Notification.Name("showPin")
        NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
        print("didSet")
    }
}
var stationsGood2Go: Bool = false {
    didSet {
        let peru = Notification.Name("stationPin")
        NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
        print("didSet")
    }
}
