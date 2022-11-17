//
//  FeatureListModel.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/9/1.
//

import Foundation
import SwiftUI

enum FeatureType {
    case modifyComplication
    case scheduleBackgroundTask
    case healthKit
    case showAlert
    case physicalTherapy
}


struct Feature: Identifiable {
    let title: String
    let emoji: String
    let color: UIColor
    let type: FeatureType
    
    var id: Int {
        return type.hashValue
    }
}

class FeatureListModel: ObservableObject {
    @Published var features: [Feature] = [
        Feature(title: "Modify Complication", emoji: "🐵", color: .brown, type: .modifyComplication),
        Feature(title: "Schedule background task", emoji: "🐡", color: .blue, type: .scheduleBackgroundTask),
        Feature(title: "HealthKit", emoji: "💪🏻", color: .orange, type: .healthKit),
        Feature(title: "Physical Therapy", emoji: "🤸‍♂️", color: .white, type: .physicalTherapy),
        Feature(title: "Show alert", emoji: "ⓘ", color: .yellow, type: .showAlert)
    ]
}
