//
//  PhysicalTherapySessionProvider.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/9/5.
//

import Foundation
import WatchKit

class PhysicalTherapySessionProvider: NSObject, ObservableObject {
    weak var timer: Timer? = nil
    @Published var count: Int = 30
    var session: WKExtendedRuntimeSession?
    
    func start() {
        session = WKExtendedRuntimeSession()
        session?.delegate = self
        session?.start()
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(self.startCountdown), userInfo: nil, repeats: true)
        
    }
    
    func stop() {
        session?.invalidate()
        session = nil
        timer?.invalidate()
        timer = nil
        count = 30
    }
    
    @objc func startCountdown() {
        if count == 0 {
            WKInterfaceDevice.current().play(.stop)
            stop()
            return
        }
        
        count = count - 1
        if count % 10 == 0 {
            WKInterfaceDevice.current().play(.success)
        }
    }
    
}

extension PhysicalTherapySessionProvider: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        if let error = error {
            print("wk extendedRuntimeSession error:\(error.localizedDescription)")
        }
        
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("wk extendedRuntimeSessionDidStart")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("wk extendedRuntimeSessionWillExpire")
    }
}
