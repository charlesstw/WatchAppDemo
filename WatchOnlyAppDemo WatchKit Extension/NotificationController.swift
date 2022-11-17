//
//  NotificationController.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/23.
//

import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {
    var title: String?
    var message: String?
    var icon: String?
    
    override class var isInteractive: Bool {
        return true
    }
    
    override var body: NotificationView {
        return NotificationView(title: title, message: message, icon: icon)
    }

    override func willActivate() {
        print("wk NotificationController willActivate")
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        print("wk NotificationController didDeactivate")
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        print("wk recieve notification")
        let notificationData =
            notification.request.content.userInfo as? [String: Any]
        
        let aps = notificationData?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        title = alert?["title"] as? String
        message = alert?["message"] as? String
        icon = alert?["icon"] as? String
        
    }
    
}
