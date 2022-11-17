//
//  DetailView.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/9/2.
//

import HealthKit
import SwiftUI

struct HealthDetailView: View {
    let health: HealthKitProvider = ExtensionDelegate.shared.healthProvider
    @State var height: String = "??"
    @State var steps: Int = -1
    @State private var showingAlert = false
    @State private var userSetHeight: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("🧍")
                    .font(.title)
                Text("\(height)")
                    .font(.system(.headline, design: .rounded))
            }
            HStack {
                Text("🏃‍♀️")
                    .font(.title)
                Text("\(steps)")
                    .font(.system(.headline, design: .rounded))
            }
            if #available(watchOSApplicationExtension 8.0, *) {
                Button {
                    presentInputController()
                } label: {
                    Text("Set height")
                }
                
            } else {}
        }.onAppear {
            getHealthData()
        }
    }
    
    private func presentInputController() {
        presentInputController(withSuggestions: []) { result in
            if let height = Double(result) {
                health.setHeight(height)
            }
        }
    }
    
    func getHealthData() {
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date().addingTimeInterval(10), userInfo: nil) { error in
            print("wk scheduleBackgroundRefresh error:\(String(describing: error?.localizedDescription))")
        }
        
        height = ExtensionDelegate.shared.healthProvider.height
        steps = ExtensionDelegate.shared.healthProvider.currentSteps
        health.authorizeHealthKit { success, error in
            if success {
                let heightSample = HKSampleType.quantityType(forIdentifier: .height)
                self.health.getHeight(sampleType: heightSample!) { height, error in
                    
                    if let height = height {                        
                        self.height = "\(height) m"
                                                
                    } else if let error = error {
                        print("wk height data fail:\(error.localizedDescription)")
                    }
                }
                
                self.health.getTodaysSteps { steps in
                    print("step:\(Int(steps))")
                    self.steps = Int(steps)
                    ExtensionDelegate.shared.updateComplications()
                }
            } else {
                print("wk health data fail:\(String(describing: error?.localizedDescription))")
            }
        }
    }
}

struct HealthDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HealthDetailView()
    }
}

extension View {
    typealias StringCompletion = (String) -> Void
    
    func presentInputController(withSuggestions suggestions: [String], completion: @escaping StringCompletion) {
        WKExtension.shared()
            .visibleInterfaceController?
            .presentTextInputController(withSuggestions: suggestions,
                                        allowedInputMode: .plain) { result in
                
                guard let result = result as? [String], let firstElement = result.first else {
                    completion("")
                    return
                }
                
                completion(firstElement)
            }
    }
}
