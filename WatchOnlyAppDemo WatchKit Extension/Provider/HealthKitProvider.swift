//
//  HealthKitProvider.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/9/1.
//

import Foundation
import HealthKit

enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}

class HealthKitProvider {
    var currentSteps: Int {
        set {
            print("set current step:\(newValue)")
            UserDefaults.standard.set(newValue, forKey: "steps")
        }
        get {
            let current = UserDefaults.standard.integer(forKey: "steps")
            print("get current step:\(current)")
            return current
        }
    }
    var height = ""
    private let healthStore = HKHealthStore()

    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }

        // 2. Prepare the data types that will interact with HealthKit
//        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
//              let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
//              let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
//              let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
//              let height = HKObjectType.quantityType(forIdentifier: .height),
//              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
//              let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
//              let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)
//        else {
//            completion(false, HealthkitSetupError.dataTypeNotAvailable)
//            return
//        }

        guard let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount), let height = HKObjectType.quantityType(forIdentifier: .height) else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }

        // 3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [height]

        let healthKitTypesToRead: Set<HKObjectType> = [height,
                                                       stepCount,
                                                       HKObjectType.workoutType()]

        // 4. Request Authorization
        self.healthStore.requestAuthorization(toShare: healthKitTypesToWrite,
                                              read: healthKitTypesToRead) { success, error in
            completion(success, error)
        }
    }
    
    func setHeight(_ height: Double){
        guard let type = HKQuantityType.quantityType(forIdentifier: .height) else {
            return 
        }
        let unit = HKUnit.meter()
        let quantity = HKQuantity(unit: unit, doubleValue: height)
        if #available(watchOSApplicationExtension 8, *) {
            let height = HKQuantitySample(type: type, quantity: quantity, start: .now, end: .now)
            self.healthStore.save(height) { isComplete, error in
                
            }
        }
    }

    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                print("current step error")
                self.currentSteps = 0
                completion(0.0)
                return
            }
            let step = Int(sum.doubleValue(for: HKUnit.count()))
            print("current step:\(step)")
            self.currentSteps = step
            completion(sum.doubleValue(for: HKUnit.count()))
        }

        self.healthStore.execute(query)
    }

    func getHeight(sampleType: HKSampleType, completion: ((String?, Error?) -> Void)?) {
        // Predicate for the height query
        let distantPastHeight = NSDate.distantPast as Date
        let currentDate = NSDate() as Date
        let lastHeightPredicate = HKQuery.predicateForSamples(withStart: distantPastHeight, end: currentDate, options: .strictEndDate)

        // Get the single most recent height
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        // Query HealthKit for the last Height entry.
        let heightQuery = HKSampleQuery(sampleType: sampleType, predicate: lastHeightPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, error in

            if let queryError = error {
                completion?(nil, queryError)
                return
            }

            // Set the first HKQuantitySample in results as the most recent height.
            let lastHeight = results!.first
            
            if let height = (lastHeight as? HKQuantitySample)?.quantity.doubleValue(for: HKUnit.meter()) {
                print("height:\(height)")
                self.height = "\(height)"
            }                        
            completion?(self.height, nil)
            
        }
        // Time to execute the query.
        healthStore.execute(heightQuery)
    }
}
