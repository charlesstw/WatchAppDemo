//
//  ContentView.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/23.
//

import ClockKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var model: FeatureListModel
    @State private var showingAlert = false
    @State private var isShowingCountdownView = false

    var body: some View {
        List {
            ForEach(model.features) { feature in

                switch feature.type {
                case .modifyComplication:
                    Button {
                        ExtensionDelegate.shared.toggleMonkey()
                        ExtensionDelegate.shared.updateComplications()
                    } label: {
                        Cell(feature: feature)
                    }

                case .scheduleBackgroundTask:
                    Button {
                        print("wk click background url button")
                        ExtensionDelegate.shared.backgroundDataProvider.schedule(true)
                    } label: {
                        Cell(feature: feature)
                    }
                case .healthKit:
                    NavigationLink {
                        HealthDetailView()
                    } label: {
                        Cell(feature: feature)
                    }
                case .showAlert:
                    Button {
                        showingAlert = true
                    } label: {
                        Cell(feature: feature)
                    }
                    .alert(isPresented: $showingAlert, content: {
                        Alert(title: Text("測試 alert"), message: Text("Message"), dismissButton: .cancel(Text("Confirm")))
                    })
                case .physicalTherapy:
                    NavigationLink(isActive: $isShowingCountdownView) {
                        CountdownView(ptSessionProvider: PhysicalTherapySessionProvider())
                    } label: {
                        Cell(feature: feature)
                    }
                }
            }
        }.listStyle(CarouselListStyle())
    }

    private func secondsValue(for date: Date) -> Double {
        let seconds = Calendar.current.component(.second, from: date)
        return Double(seconds) / 60
    }
}

struct Cell: View {
    var feature: Feature

    var body: some View {
        HStack {
            Text(feature.emoji)
                .font(.title)
            Text(feature.title)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(feature.color))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(model: FeatureListModel())
                .previewDevice("Apple Watch Series 5 - 40mm")
            ContentView(model: FeatureListModel())
                .previewDevice("Apple Watch Series 7 - 45mm")
        }
    }
}
