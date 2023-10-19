//
//  MetricsView.swift
//  Workouts Watch App
//
//  Created by Hamid Kouidri on 18/10/2023.
//

import SwiftUI


struct MetricsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ElapsedTimeView(
                elapsedTime: 3 * 60 + 15.24,
                showSubseconds: true
            ).foregroundColor(Color.yellow)
            Text(
                Measurement(value: 47, unit: UnitEnergy.kilocalories)
                    .formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout
                        )
                    )
                )
            Text(
                153.formatted(
                    .number.precision(.fractionLength(0))
                )
                + " bpm"
            )
            Text(
                Measurement(
                    value: 515,
                    unit: UnitLength.meters
                ).formatted(
                    .measurement(
                        width: .abbreviated,
                        usage: .road
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

#Preview {
    MetricsView()
}
