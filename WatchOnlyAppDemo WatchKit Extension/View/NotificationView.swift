//
//  NotificationView.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/23.
//

import SwiftUI

struct NotificationView: View {
    let title: String?
    let message: String?
    let icon: String?
    
    var body: some View {
        VStack {
            if let icon = icon {
                IconView(text: icon)
            }
            Text(title ?? "Unknown title")
                .font(.headline)
                .lineLimit(0)
            Divider()
            Text(message ?? "")
                .font(.caption)
            Button {
                UserDefaults.standard.set("🐒", forKey: "monkey")
                ExtensionDelegate.shared.updateComplications()
            } label: {
                Text("🐒")
            }

        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(title: "TestTitle", message: "Build watchOS apps that use features the app delegate monitors or controls, such as background tasks and extended runtime sessions.", icon: "🐨")
    }
}
