//
//  ExtensionDelegate.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/24.
//

import ClockKit
import HealthKit
import UserNotifications
import WatchKit
import PushKit

final class ExtensionDelegate: NSObject, WKExtensionDelegate {
    static var shared: ExtensionDelegate!
    let backgroundDataProvider: BackgroundDataProvider = .init()
    let pushNotificationProvider: PushNotificationProvider = .init()
    let center = UNUserNotificationCenter.current()
    let healthProvider = HealthKitProvider()
    
    func applicationDidFinishLaunching() {
        print("wk did finish launching")
        WKExtension.shared().registerForRemoteNotifications()
//        pushNotificationProvider.startPushKit() // TODO: not work
        requestAPNSAuthorization()
        
    }

    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        var tokenString = ""
        for byte in deviceToken {
            let hexString = String(format: "%02x", byte)
            tokenString += hexString
        }
        print(tokenString)
        let base64Token = deviceToken.base64EncodedString()
        print("bass64:\(base64Token)")
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        print("wk background task:\(backgroundTasks)")
        
        for task in backgroundTasks {
            switch task {
            case let backgroundRefreshTask as WKApplicationRefreshBackgroundTask:
                //if let userInfo: NSDictionary = task.userInfo as? NSDictionary {
                // get user info data
                // update active complication
                // schedule next background refresh
                // then setTaskCompletedWithSnapshot
                print("wk background task backgroundRefreshTask")
                
                healthProvider.getTodaysSteps { steps in
                    self.updateComplications()
                    WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date().addingTimeInterval(15), userInfo: nil) { error in
                        print("wk scheduleBackgroundRefresh error:\(String(describing: error?.localizedDescription))")
                        backgroundRefreshTask.setTaskCompletedWithSnapshot(false)
                    }
                }
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                print("wk background task WKURLSessionRefreshBackgroundTask")
                
                // then setTaskCompletedWithSnapshot
                backgroundDataProvider.refresh { _ in
                    print("url sessoin refresh backgorund task")
                    // update active complication
                    if let emoji = UserDefaults.standard.string(forKey: "fish"), emoji == "🐳" {
                        UserDefaults.standard.set("🐬", forKey: "fish")
                    } else {
                        UserDefaults.standard.set("🐳", forKey: "fish")
                    }
                    
                    self.updateComplications()
                    
                    // schedule next background refresh
                    self.backgroundDataProvider.schedule(false)
                    
                    urlSessionTask.setTaskCompletedWithSnapshot(false)
                }
                
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (WKBackgroundFetchResult) -> Void) {
        print("wk receive notification:\(userInfo)")
        UserDefaults.standard.set("🦍", forKey: "monkey")
        updateComplications()
        completionHandler(.newData)
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        print("wk register notification fail:\(error.localizedDescription)")
    }
    
    func requestAPNSAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.center.requestAuthorization(options: options) { _, _ in
                }
            case .authorized:
                print("auth success")
            default:
                print("other error")
            }
        }
    }
}

extension ExtensionDelegate {
    func updateComplications() {
        guard let allComplications = CLKComplicationServer.sharedInstance().activeComplications else {
            return
        }
        for complication in allComplications {
            CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
        }
    }
    
    func toggleMonkey() {
        if let monkey = UserDefaults.standard.string(forKey: "monkey"), monkey == "🙈" {
            UserDefaults.standard.set("🐵", forKey: "monkey")
        } else {
            UserDefaults.standard.set("🙈", forKey: "monkey")
        }
    }
}
