import SwiftUI

struct StationSelectionPage: View {
    var body: some View {
        VStack(spacing: 20) {
            StoryListView()
            StationSelector()
            Spacer()
        }
    }
}

#Preview {
    StationSelectionPage()
}
