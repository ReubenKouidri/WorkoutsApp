//
//  WorkoutsApp.swift
//  Workouts Watch App
//
//  Created by Hamid Kouidri on 18/10/2023.
//

import SwiftUI

@main
struct Workouts_Watch_AppApp: App {
    @StateObject var workoutManager = WorkoutManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .environmentObject(workoutManager)
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
