
import SwiftUI

struct ControlsView: View {
    var body: some View {
        HStack{  // horizontal display
            VStack {  // VStack a Button and Text below it
                Button {
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(Color.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button {
                } label: {
                    Image(systemName: "pause")
                }
                .tint(.yellow)
                .font(.title2)
                Text("Pause")
            }
        }
    }
}

#Preview {
    ControlsView()
}
