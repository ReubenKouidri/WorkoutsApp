//
//  ElapsedTimeView.swift
//  Workouts Watch App
//
//  Created by Hamid Kouidri on 18/10/2023.
//

import SwiftUI


struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()
    
    var body: some View {
        // cast elapsedTime to NSNumber obj so timeFormatter can use it
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: showSubseconds) {
                timeFormatter.showSubseconds = showSubseconds // when var showSubseconds changes, timeFormatter.showSubseconds also changes
            }
    }
}

class ElapsedTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = true
    
    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else { return nil }  // ensure 'value' is a TimeInterval. Asign to constant 'string'
        guard let formattedString = componentsFormatter.string(from: time) else { return nil }  // ensure componentsFormatter returned String, asign const
        if showSubseconds {  // if showSubseconds == true
            let hundreths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)  // get the remainder e.g. t = 2.154s => hundreths = .154 * 100 = 15.4.
                                                                                  // Int => 15
            let decimalSeparator = Locale.current.decimalSeparator ?? "."  // ?? == nil coalescing operator e.g. resort to "." if !Locale.current...
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundreths)  // format string <=> C equiv. "%s%s%.2d", ...
        }
        
        return formattedString  // if showSubseconds == false, return the unformatted string
    }
}

#Preview {
    ElapsedTimeView()
}
