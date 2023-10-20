
import SwiftUI

@main
struct Workouts_Watch_AppApp: App {
    @StateObject var workoutManager = WorkoutManager()  // StateObjects allow the View to be updated instead of recreated due to updating Views
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {  // bind to showingSummaryView, i.e. true or false
                SummaryView()
            }
            .environmentObject(workoutManager)
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
