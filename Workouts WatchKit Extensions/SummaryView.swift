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
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss  // adds ability to dismiss the sheet
    @State private var durationFormatter:
    
    DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]  // displays hours, mins, secs, separated by colons
        formatter.zeroFormattingBehavior = .pad  // pads zeros
        return formatter
    }()
    
    var body: some View {
        if workoutManager.workout == nil {
            ProgressView("Saving Workout")
                .navigationBarHidden(true)
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    SummaryMetricView(
                        title: "Total Time",
                        value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? ""
                    ).accentColor(.yellow)
                    
                    SummaryMetricView(
                        title: "Total Distance",
                        value: Measurement(
                            value: workoutManager.workout?.totalDistance?.doubleValue(for: .meter()) ?? 0,
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
                            value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
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
                        value: workoutManager.averageHeartRate.formatted(
                            .number.precision(.fractionLength(0))
                        )
                        + " bpm"
                    ).accentColor(.red)
                    
                    Text("Activity Rings")
                    ActivityRingsView(
                        healthStore: workoutManager.healthStore
                    ).frame(width: 50, height: 50)
                    
                    Button("Done"){
                        dismiss()
                    }
                }
                .scenePadding()  // make text views and dividers align with navBar title
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
            
        }
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
        .environmentObject(WorkoutManager())
}
