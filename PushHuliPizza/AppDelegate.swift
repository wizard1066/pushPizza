//
//  AppDelegate.swift
//  PushHuliPizza
//
//  Created by Mark Lucking on 1/13/17.
//  Copyright © 2017 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

struct ColorSet {
    var colors = Set<String>()
}

var colorFucker: ColorSet?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var colorZet = Set<String>()
    var tagZet = Set<String>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setCategories()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            if granted{
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
               print("User Notification permission denied: \(error?.localizedDescription)")
            }
        }
        
        
        return true
    }
    
    func tokenString(_ deviceToken:Data) -> String{
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format:"%02x",byte)
        }
        return token
    }
    
    func setCategories(){
        let snoozeAction = UNNotificationAction(identifier: "snooze.action", title: "Snooze", options: [])
        let snoozeCategory = UNNotificationCategory(identifier: "pizza.category", actions: [snoozeAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([snoozeCategory])
    }
    
    func changePizzaNotificationContent(content oldContent:UNNotificationContent)-> UNMutableNotificationContent{
        let content = oldContent.mutableCopy() as! UNMutableNotificationContent
        let userInfo = content.userInfo as! [String:Any]
        //add the subtitle
        if let subtitle = userInfo["subtitle"] {
            content.subtitle = subtitle as! String
        }
        
        if let orderEntry = userInfo["order"]{
            let orders = orderEntry as! [String]
            var body = ""
            for item in orders{
                body += item + ", "
            }
            content.body = body
        }
        return content
    }
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata) {
        
        let acceptSharing: CKAcceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        
        acceptSharing.qualityOfService = .userInteractive
        acceptSharing.perShareCompletionBlock = {meta, share, error in
            print("successfully shared \(meta) \(share) \(error)")
        }
        acceptSharing.acceptSharesCompletionBlock = {
            error in
            guard (error == nil) else{
                print("Error \(error?.localizedDescription ?? "")")
                return
            }
            
//            let viewController: AddItemViewController =
//                self.window?.rootViewController as! AddItemViewController
            self.fetchShare(cloudKitShareMetadata)
            
        }
        CKContainer(identifier: cloudKitShareMetadata.containerIdentifier).add(acceptSharing)
    }
    
    var item: CKRecord!
    
    func fetchShare(_ cloudKitShareMetadata: CKShareMetadata){
        let op = CKFetchRecordsOperation(
            recordIDs: [cloudKitShareMetadata.rootRecordID])
        
        op.perRecordCompletionBlock = { record, _, error in
            if error != nil {
                print("error \(error?.localizedDescription)")
                return
            }
            self.item = record
        }
        op.fetchRecordsCompletionBlock = { records, error in
            if error != nil {
                print("fuck2 error \(error?.localizedDescription)")
                return
            }
            print("record \(self.item)")
            let line2S = self.item.object(forKey: remoteAttributes.lineName) as! String
            let station2S = self.item.object(forKey: remoteAttributes.stationNames) as! [String]
            let line2ID = self.item.object(forKey: remoteAttributes.lineRecordID) as! String
            linesRead = [line2S]
            stationsRead = station2S
            let peru = Notification.Name("stationPin")
            NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
            let peru2 = Notification.Name("showPin")
            NotificationCenter.default.post(name: peru2, object: nil, userInfo: nil)
            cloudDB.share.logToken(token2Save: ownerToken, lineName: linesRead.first!)
            
        }
        CKContainer.default().sharedCloudDatabase.add(op)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successful registration. Token is:")
        print(tokenString(deviceToken))
        ownerToken = tokenString(deviceToken)
        // fuck
        cloudDB.share.setToken(token2Set: ownerToken)
//        let peru = Notification.Name("refresh")
//        NotificationCenter.default.post(name: peru, object: nil, userInfo: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register \(error.localizedDescription)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
//MARK: Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert,.sound,.badge])
        let userInfo = notification.request.content.userInfo as! [String:Any]
        completionHandler([.alert,.sound,.badge])
        //add the subtitle
        
        if let _ = userInfo["station"] as? String {
            if let _ = userInfo["line"] as? String {
                completionHandler([.alert,.sound,.badge])
            } else {
                completionHandler([])
            }
        } else {
            completionHandler([])
        }
//        if let color2U = userInfo["station"] {
//            let color2UX = color2U as! String
//            let tag2U = userInfo["line"]
//            let tag2UX = tag2U as! String
//            if (colorZet.contains(color2UX) && tagZet.contains(tag2UX)) {
//                completionHandler([.alert,.sound,.badge])
//            } else {
//                completionHandler([])
//            }
//        }
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let action = response.actionIdentifier
        let request = response.notification.request
        
        if action == "snooze.action"{
            let content = changePizzaNotificationContent(content: request.content)
            let snoozeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            let snoozeRequest = UNNotificationRequest(identifier: "pizza.snooze", content: content, trigger: snoozeTrigger)
            UNUserNotificationCenter.current().add(snoozeRequest, withCompletionHandler: { (error) in
                if error != nil {
                    print("Snooze Error: \(error?.localizedDescription)")
                }
            })
        }
        
        completionHandler()
    }
}
















