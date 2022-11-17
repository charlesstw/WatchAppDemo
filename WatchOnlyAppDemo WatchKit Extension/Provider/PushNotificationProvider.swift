//
//  PushNotificationProvider.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/26.
//

import Foundation
import PushKit

class PushNotificationProvider: NSObject, PKPushRegistryDelegate {
    func startPushKit() {
        print("startPushKit")
        let pushRegistry = PKPushRegistry(queue: .main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.complication]
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        // send credential to server
        print("wk push credential:\(pushCredentials)")
        print("wk push credential:\(pushCredentials.token)")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("wk push didInvalidatePushTokenFor")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        // update complication
        completion()
    }
}
