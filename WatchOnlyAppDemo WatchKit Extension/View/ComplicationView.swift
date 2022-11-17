//
//  ComplicationView.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/29.
//

import ClockKit
import SwiftUI

struct ComplicationViewCircular: View {
    @Environment(\.complicationRenderingMode) var renderingMode
    @State var progress = 0.9
    var title: String
    var color: Color

    var body: some View {
        if renderingMode == .fullColor {
            let _ = print("full color")
            ProgressView(
                title,
                value: progress,
                total: 1.0)
                .progressViewStyle(
                    CircularProgressViewStyle(tint: color))
            
        } else {
            let _ = print("tint color")
            ProgressView(
                title,
                value: progress,
                total: 1.0)
                .progressViewStyle(
                    CircularProgressViewStyle())
        }

        
    }
}

struct ComplicationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ComplicationViewCircular(progress: 0.1, title: "👟\(12)", color: .yellow)
        }
    }
}
