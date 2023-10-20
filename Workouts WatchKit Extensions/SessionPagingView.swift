//
//  SessionPagingView.swift
//  Workout
//
//  Created by Hamid Kouidri on 18/10/2023.
//

import SwiftUI
import WatchKit

/* allows swipe between View

 
 -----------     -----------     -----------
|           |   |           |   |           |
| CONTROLS  |   |  METRICS  |   |   NEXT    |
|    GO     |-> |   HERE    |-> |   ETC.    |
|   HERE    |   |           |   |           |
|           |   |           |   |           |
 -----------     -----------     -----------
 
*/


struct SessionPagingView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selection: Tab = .metrics  // State variable
    
    enum Tab {
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection) {
                ControlsView().tag(Tab.controls)  // tags allow selection
                MetricsView().tag(Tab.metrics)
                NowPlayingView().tag(Tab.nowPlaying)
            }
        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        .navigationBarBackButtonHidden(true)  // do not go back to start view whilst in a workout
        .navigationBarHidden(selection == .nowPlaying)
        .onChange(of: workoutManager.running) {
            displayMetricsView()
        }
        .tabViewStyle(
            PageTabViewStyle( indexDisplayMode: isLuminanceReduced ? .never : .automatic )
        )
        .onChange(of: isLuminanceReduced) {
            displayMetricsView()
        }
    }
    
    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
}

#Preview {
    SessionPagingView()
        .environmentObject(WorkoutManager())
}
