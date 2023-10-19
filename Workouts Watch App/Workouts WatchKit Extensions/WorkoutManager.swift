
import Foundation
import HealthKit


class WorkoutManager: NSObject, ObservableObject {
    var selectedWorkout: HKWorkoutActivityType? { // track selected workout
        didSet { // tracker so that whenever this changes, startWorkout is called
            guard let selectedWorkout = selectedWorkout else { return }  // only call selected workout if selectedWorkoutis not nil
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    // request authorisation to use personal data
    func requestAuthorisation() {
        // quantity type to write to the heathStore
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // read data types automatically recorded by apple watch
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!,
            HKQuantityType.quantityType(forIdentifier: .atrialFibrillationBurden)!,
            HKObjectType.activitySummaryType()  // permission to read activity rings summary
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // handle error
        }
    }
    
    
    
    let healthStore = HKHealthStore()  //
    var session: HKWorkoutSession?  //
    var builder: HKLiveWorkoutBuilder?  //
    
    func startWorkout(workoutType: HKWorkoutActivityType) {  // e.g. .running, .climbing, etc...
        let configuration  = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor  // if all workouts are outdoors. This determines how the builder and session behave
        // e.g. outdoor will generate GPS data whereas indoor does not
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            print("Error occured in workoutManager")
            return
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration  // takes in the config
        )  // dataSource will automatically provide live data from a workout session
        
        // start session and begin collecting data
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // the workout has started
        }
    }
    
    
}
