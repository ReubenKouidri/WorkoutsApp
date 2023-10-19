//
//  ActivityRingsView.swift
//  Workouts Watch App
//
//  Created by Hamid Kouidri on 18/10/2023.
//

import Foundation
import HealthKit
import SwiftUI

struct ActivityRingsView: WKInterfaceObjectRepresentable {
    let healthStore: HKHealthStore  // needed for initialisation
    
    func makeWKInterfaceObject(context: Context) -> some WKInterfaceObject {
        let activityRingsObject = WKInterfaceActivityRing()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day], from: Date())  // date components from today = Date()
        components.calendar = calendar
        
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        
        let query = HKActivitySummaryQuery(predicate: predicate) {
            query, summaries, error in DispatchQueue.main.async {
                activityRingsObject.setActivitySummary(summaries?.first, animated: true)
            }
        }
        healthStore.execute(query)  // execute query on HKHealthStore
        
        return activityRingsObject
    }
    
    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceObjectType, context: Context) {

        }
    
    
    
}
