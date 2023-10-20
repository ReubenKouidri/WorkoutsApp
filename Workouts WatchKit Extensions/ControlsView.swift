
import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        HStack{  // horizontal display
            VStack {  // VStack a Button and Text below it
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(Color.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button {
                    workoutManager.togglePause()
                } label: {
                    Image(systemName: workoutManager.running ? "pause" : "play")
                }
                .tint(.yellow)
                .font(.title2)
                Text(workoutManager.running ? "Pause" : "Resume")
            }
        }
    }
}

#Preview {
    ControlsView()
        .environmentObject(WorkoutManager())
}
