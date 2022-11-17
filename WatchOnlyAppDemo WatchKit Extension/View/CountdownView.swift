//
//  CountdownView.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/9/5.
//

import SwiftUI

struct CountdownView: View {
    @ObservedObject var ptSessionProvider: PhysicalTherapySessionProvider
    var body: some View {
        Text("\(ptSessionProvider.count)")
            .font(.system(size: 100))
            .onAppear {
                ptSessionProvider.start()
            }.onDisappear {
                ptSessionProvider.stop()
            }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(ptSessionProvider: PhysicalTherapySessionProvider())
    }
}
