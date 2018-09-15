//
//  CloudKitMethods.swift
//  PushHuliPizza
//
//  Created by localadmin on 14.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import Foundation
import CloudKit

var keyStore = NSUbiquitousKeyValueStore()

func icloudStatus() -> Bool?{
    return FileManager.default.ubiquityIdentityToken != nil ? true : false
}

func returnURLgivenKey(key2search: String, typeOf: String) -> String? {
    let searchString2U = key2search + typeOf
    if let storedURL = keyStore.string(forKey: searchString2U) {
        return storedURL
    } else {
        return nil
    }
}

func storeURLgivenKey(key2Store: String, URL2Store: String, pass2U: String) {
    let URLkey2U = key2Store + ".URL"
    let passKey2U = key2Store + ".PASS"
    keyStore.set(URL2Store, forKey: URLkey2U)
    keyStore.set(pass2U, forKey: passKey2U)
    keyStore.synchronize()
}
