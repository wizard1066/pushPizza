//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by localadmin on 26.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    
    @IBOutlet weak var photo2D: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        let userInfo = content.userInfo as! [String:Any]
        if let urlString = userInfo["image-url"] {
            let url = URL(string: (urlString as! String))
            // check url exists
            let dataDownloaded = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.photo2D.image = UIImage(data: dataDownloaded!)
                }
            }
        }
    }


