//
//  SummaryView.swift
//  Workouts Watch App
//
//  Created by Hamid Kouidri on 18/10/2023.
//
/*
 HealthKit: 
            HKWorkoutSession allows collection of data during workout e.g. HR.
            All data isn stored in HealthKit.
            Allows collection to runin background whilst workout is active

 HKLiveWorkoutBuilder:
            create and save a HKWorkout obj. 
            Automatically collects samples and events
            -- see WWDC18 Sessoin for more
 
 WorkoutManager:
            Interfaces with HKWorkoutSession to start, pause, and end workout;
            Interfaces with HKLiveWorkoutBuilder to get data from workout samples and provide the data to our vViews
            Is an Environment obj
            NavigationView will have a WorkoutManager env. obj. and will propagate it on to the Views
            Views will then declare an @EnvironmentObject to gain access to WorkoutManager
            
 
 
 */




import SwiftUI
import HealthKit

struct SummaryView: View {
    @State private var durationFormatter:
    DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]  // displays hours, mins, secs, separated by colons
        formatter.zeroFormattingBehavior = .pad  // pads zeros
        return formatter
    }()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                SummaryMetricView(
                    title: "Total Time",
                    value: durationFormatter.string(from: 30 * 60 + 15) ?? ""
                ).accentColor(.yellow)
                
                SummaryMetricView(
                    title: "Total Distance",
                    value: Measurement(
                        value: 1645,
                        unit: UnitLength.meters
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .road
                        )
                    )
                ).accentColor(.green)
                
                SummaryMetricView(
                    title: "Total Energy",
                    value: Measurement(
                        value: 96,
                        unit: UnitEnergy.kilocalories
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout
                        )
                    )
                ).accentColor(.pink)
                
                SummaryMetricView(
                    title: "Avg. HR",
                    value: 143.formatted(
                        .number.precision(.fractionLength(0))
                    )
                    + " bmp"
                ).accentColor(.red)
                
                Text("Activity Rings")
                ActivityRingsView(
                    healthStore: HKHealthStore()
                ).frame(width: 50, height: 50)
                
                Button("Done"){
                }
            }
            .scenePadding()  // make text views and dividers align with navBar title
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}


struct SummaryMetricView: View {
    var title: String
    var value: String
    
    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                .lowercaseSmallCaps()
            )
            .foregroundColor(.accentColor)
        Divider()
    }
}


#Preview {
    SummaryView()
}
