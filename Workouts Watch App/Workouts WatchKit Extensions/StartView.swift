//
//  ContentView.swift
//  Workouts Watch App
//
//  Created by Hamid Kouidri on 18/10/2023.
//

import SwiftUI
import HealthKit


struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [HKWorkoutActivityType] = [.climbing, .coreTraining, .functionalStrengthTraining, .running]
    
    var body: some View {
        NavigationStack {
            List(workoutTypes) {workoutType in
                // create a navlink for all workouts in list workoutTypes
                // this links to the destination View when clicked on
                NavigationLink(
                    workoutType.name,
                    value: workoutType
                    // !!DEPRICATED!!
                    // destination: SessionPagingView(),
                    // tag: workoutType,
                    // selection: $workoutManager.selectedWorkout  // binding to the selectedWorkout in workoutManager
                )
                .navigationDestination(for: HKWorkoutActivityType.self) { workout in
                    SessionPagingView()
                }
                .padding(EdgeInsets(top: 15, leading: 5, bottom:15, trailing: 5))  // add padding to give a larger tap area
                
            }
            .listStyle(.carousel)  // provides depth effect
            .navigationBarTitle("Workouts")  // set title at top
            .onAppear {
                workoutManager.requestAuthorisation()
            }
        }
    }
}


// extend HKWorkoutActivityType by using the 'Identifiable' protocol
extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    var name: String {
        switch self {
        case .climbing:
            return "Climb"
        case .coreTraining:
            return "Core"
        case .functionalStrengthTraining:
            return "Strength"
        case .running:
            return "Running"
        default:
            return ""
        }
    }
}



#Preview {
    StartView()
        .environmentObject(WorkoutManager())
}
