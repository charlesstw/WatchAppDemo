//
//  WatchOnlyAppDemoApp.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/23.
//

import SwiftUI

@main
struct WatchOnlyAppDemoApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) private var extensionDelegate
    
    init() {
        ExtensionDelegate.shared = self.extensionDelegate
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(model: FeatureListModel())
            }
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")        
    }
}
