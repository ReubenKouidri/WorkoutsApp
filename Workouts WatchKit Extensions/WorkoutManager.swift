
import Foundation
import HealthKit


class WorkoutManager: NSObject, ObservableObject {
    var selectedWorkout: HKWorkoutActivityType? { // track selected workout
        didSet { // tracker so that whenever this changes, startWorkout is called
            guard let selectedWorkout = selectedWorkout else { return }  // only call selected workout if selectedWorkout is not nil
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    // when workout ends, change showingSummaryView to true
    @Published var showingSummaryView: Bool = false {
        didSet {
            // Sheet dismissed
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    
    // MARK: Request Auth
    // to use personal data
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
            HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!,
            //HKQuantityType.quantityType(forIdentifier: .atrialFibrillationBurden)!,
            HKObjectType.activitySummaryType()  // permission to read activity rings summary
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // handle error
        }
    }
    
    
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    // MARK: Start Workout
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
        
        session?.delegate = self
        builder?.delegate = self
        
        // start session and begin collecting data
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // the workout has started
        }
    }
    
    // MARK: - State Control
    // The workout session state
    @Published var running = true  // @Published => changes to this variable will automatically trigger UI updates if being observed by Views
    
    func pause() {
        session?.pause()
    }
    
    func resume() {
        session?.resume()
    }
    
    func togglePause() {
        if running {
            pause()
        }
        else {
            resume()
        }
    }
    
    func endWorkout() {
        session?.end()
        showingSummaryView = true
    }
    
    // MARK: Workout Metrics
    @Published var averageHeartRate: Double = 0  // used by summary view
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    
    func updateForStatistics(_ statistics: HKStatistics?) {  // takes an optional type
        guard let statistics = statistics else { return }  // return if statistics is nil
        
        DispatchQueue.main.async {  // dispatch updates async to the main queue
            switch statistics.quantityType {  // switch through each quantity type
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
                HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
                
            default:
                return
            }
        }
    }
    
    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
}


// MARK: -HKWorkoutSessionDelegate
// Implement Protocol to be notified when a workout session's state changes

extension WorkoutManager: HKWorkoutSessionDelegate {
    // func is called whenever the session State changes
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // wait for the session to transition states before ending the builder
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Error occured in change of workout session")
        return
    }
}

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // called whenever the bulder collects an event
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        // called whenever the builder collects new samples
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }  // ensure collected type is a HKQuantityType
            let statistics = workoutBuilder.statistics(for: quantityType)
            //update published vars
            updateForStatistics(statistics)  // update published metric values
        }
    }
}
