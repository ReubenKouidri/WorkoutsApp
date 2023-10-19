
import SwiftUI
import HealthKit


struct StartView: View {
    // array of workout types
    var workoutTypes: [HKWorkoutActivityType] = [.climbing, .coreTraining, .functionalStrengthTraining, .running]
    
    var body: some View {
        List(workoutTypes) {workoutType in
            // create a navlink for all workouts in list workoutTypes
            // this links to the destination View when clicked on
            NavigationLink(
                workoutType.name,
                destination: Text(workoutType.name)
            ).padding(  // add padding to give a larger tap area
                EdgeInsets(top: 15, leading: 5, bottom:15, trailing: 5)
            )
            
        }
        .listStyle(.carousel)  // provides depth effect
        .navigationBarTitle("Workouts")  // set title at top
                      
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
}
