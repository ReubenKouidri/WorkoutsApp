//
//  MetricsView.swift
//  Workouts Watch App
//
//  Created by Hamid Kouidri on 18/10/2023.
//

import SwiftUI


struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())
        ) { context in
            VStack(alignment: .leading) {
                ElapsedTimeView(
                    elapsedTime:
                        workoutManager.builder?.elapsedTime ?? 0,
                    showSubseconds: context.cadence == .live  // subseconds hidden in always-on state, otherwise show them
                ).foregroundColor(Color.yellow)
                Text(
                    Measurement(
                        value: workoutManager.activeEnergy,
                        unit: UnitEnergy.kilocalories
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout
                        )
                    )
                )
                Text(
                    workoutManager.heartRate
                        .formatted(
                            .number.precision(.fractionLength(0))
                        )
                    + " bpm"
                )
                Text(
                    Measurement(
                        value: workoutManager.distance,
                        unit: UnitLength.meters
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .asProvided  // for meters
                        )
                    )
                )
            }
            .font(.system(.title, design: .rounded)
                .monospacedDigit()
                .lowercaseSmallCaps()
            )
            .frame(maxWidth: .infinity, alignment: .leading)  // modify the frame View to align by leading edge.
            // maxWidth inf sets width to largest amount dictated by the parent container
            .ignoresSafeArea(edges: .bottom)  // extend to bottom of screen so ignore bottom safe area
            .scenePadding()
        }
    }
}


private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))  // 1 per second in low f, otherwise 30
            .entries(from: startDate, mode: mode)
    }
}



#Preview {
    MetricsView()
        .environmentObject(WorkoutManager())
}
