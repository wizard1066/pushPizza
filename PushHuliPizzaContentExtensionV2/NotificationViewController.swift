//
//  NotificationViewController.swift
//  PushHuliPizzaContentExtensionV2
//
//  Created by localadmin on 15.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var body: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
//        self.label?.text = notification.request.content.body
        self.titleLabel?.text = notification.request.content.title
        self.subtitle?.text = notification.request.content.subtitle
        self.body?.text = notification.request.content.body
    }

}
