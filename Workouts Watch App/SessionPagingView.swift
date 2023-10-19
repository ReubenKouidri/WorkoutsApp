//
//  SessionPagingView.swift
//  Workout
//
//  Created by Hamid Kouidri on 18/10/2023.
//

import SwiftUI


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
    @State private var selection: Tab = .metrics  // State variable
    
    enum Tab {
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection,
                content:  {
            Text("Controls").tag(Tab.controls)  // tags allow selection
            Text("Metrics").tag(Tab.metrics)
            Text("Now Playing").tag(Tab.nowPlaying)
        })
    }
}

#Preview {
    SessionPagingView()
}
