//
//  ComplicationController.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/26.
//

import Foundation
import SwiftUI
import ClockKit

let monkeyId = "monkeyId"
let fishId = "fishId"

enum ComplicationId {
    static let monkey = "monkeyId"
    static let fish = "fishId"
    static let health = "healthId"
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration
    

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: ComplicationId.monkey, displayName: "🐵", supportedFamilies: [.graphicCircular, .circularSmall, .utilitarianSmall]),
            CLKComplicationDescriptor(identifier: ComplicationId.fish, displayName: "Background 🐬", supportedFamilies: [.graphicCircular, .utilitarianSmall]),
            CLKComplicationDescriptor(identifier: ComplicationId.health, displayName: "步數", supportedFamilies: [.graphicCircular])
            
            
        ]
        print("wk getComplicationDescriptors")
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        print("wk getTimelineEndDate")
//        handler(Date().addingTimeInterval(60))
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        print("wk getCurrentTimelineEntry")
        var template: CLKComplicationTemplate?
        switch (complication.family, complication.identifier) {
        case (.circularSmall, ComplicationId.monkey):
            let info = UserDefaults.standard.string(forKey: "monkey") ?? "no data"
            template = createCircularSmallTemplate(info: info)
        case (.circularSmall, ComplicationId.fish):
            let info = UserDefaults.standard.string(forKey: "fish") ?? "🐳"
            template = createCircularSmallTemplate(info: info)
        case (.graphicCircular, ComplicationId.monkey):
            let info = UserDefaults.standard.string(forKey: "monkey") ?? "no data"
            template = createMonkeyGraphicCircleTemplate(info: info)
        case (.graphicCircular, ComplicationId.fish):
            let info = UserDefaults.standard.string(forKey: "fish") ?? "🐳"
            template = createGraphicCircleTemplate(info: info)
        case (.graphicCircular, ComplicationId.health):
            let step = ExtensionDelegate.shared.healthProvider.currentSteps
            template = createStepsGraphicCircleTemplateSwiftUI(steps:step)
        default:
            break
        }
    
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template!)
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
//        let time = "\(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium))"
        print("wk Accessing timeline entries for dates after \(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)).")
//        var template = createTestGraphicRectangularTemplate(info: "for feature:\(time)")
        print("wk getCurrentTimelineEntry after")
//        let entry = CLKComplicationTimelineEntry(date: date.addingTimeInterval(10), complicationTemplate: template)
//        handler([entry])
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        print("wk getLocalizableSampleTemplate")
        
        var template: CLKComplicationTemplate?
        switch (complication.family, complication.identifier) {
        case (.graphicCircular, ComplicationId.monkey):
            template = createGraphicCircleTemplate(info: "🐵")
        case (.graphicCircular, ComplicationId.fish):
            template = createGraphicCircleTemplate(info: "🐟")
        case (.circularSmall, _):
            template = createCircularSmallTemplate(info: "🐟")
        case (.graphicCircular, ComplicationId.health):
            template = createStepsGraphicCircleTemplateSwiftUI(steps: 0)
        default:
            break
        }
        
    
        handler(template)
    }
}

extension ComplicationController {
    
    private func createMonkeyGraphicCircleTemplate(info: String) -> CLKComplicationTemplate {
        let randomDouble = Double.random(in: 0.1...1)

        // Create the data providers.
        let percentage = Float(randomDouble) / Float(1)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [.blue, .yellow, .red, .black],
                                                   gaugeColorLocations: [0.0, 0.25, 0.5, 0.75] as [NSNumber],
                                                   fillFraction: percentage)
        
        let textProvide = CLKSimpleTextProvider(text: "\(info)")
        let unitProvider = CLKSimpleTextProvider(text: "emoji", shortText: "m")
        unitProvider.tintColor = .blue
        
        // Create the template using the providers.
        return CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText(gaugeProvider: gaugeProvider,
                                                                         bottomTextProvider: CLKSimpleTextProvider(text: "m"),
                                                                         centerTextProvider: textProvide)
    }
        
    
    private func createGraphicCircleTemplate(info: String) -> CLKComplicationTemplate {
        let randomDouble = Double.random(in: 0.1...1)
        
        let percentage = Float(randomDouble) / Float(1)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [.white, .green, .yellow, .red],
                                                   gaugeColorLocations: [0.0, 0.25, 0.5, 0.75] as [NSNumber],
                                                   fillFraction: percentage)
        
        let textProvide = CLKSimpleTextProvider(text: "\(info)")
        
        return CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText(gaugeProvider: gaugeProvider,
                                                                         bottomTextProvider: CLKSimpleTextProvider(text: "D"),
                                                                         centerTextProvider: textProvide)
    }
    
    private func createGraphicCircleTemplateSwiftUI(info: String) -> CLKComplicationTemplate {
        let view = CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular(progress: 0.3, title: info, color: .green))
        return view
    }
    
    private func createStepsGraphicCircleTemplateSwiftUI(steps: Int) -> CLKComplicationTemplate {
        let progress = Double(steps) / 3000
        let view = CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular(progress: progress, title: "👟\(steps)", color: .yellow))
        return view
    }
    
    private func createCircularSmallTemplate(info: String) -> CLKComplicationTemplate {
        let textProvider = CLKSimpleTextProvider(text: "\(info)")
        return CLKComplicationTemplateCircularSmallSimpleText(textProvider: textProvider)
    }
    
    private func createTestGraphicRectangularTemplate(info: String) -> CLKComplicationTemplate {
                
        let imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "cat")!)
        let titleTextProvider = CLKSimpleTextProvider(text: "Demo app", shortText: "DA")
        
        let cdProvider = CLKSimpleTextProvider(text: "\(info)")
//        let unitProvider = CLKSimpleTextProvider(text: "Secode", shortText: "s")

//        let combinedMGProvider = CLKTextProvider(format: "%@ %@", cdProvider, unitProvider)
        
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [.white, .green, .yellow, .red],
                                                   gaugeColorLocations: [0.0, 0.25, 0.5, 0.75] as [NSNumber],
                                                   fillFraction: 0.5)
                
        return CLKComplicationTemplateGraphicRectangularTextGauge(headerImageProvider: imageProvider,
                                                                  headerTextProvider: titleTextProvider,
                                                                  body1TextProvider: cdProvider,
                                                                  gaugeProvider: gaugeProvider)
    }
}
