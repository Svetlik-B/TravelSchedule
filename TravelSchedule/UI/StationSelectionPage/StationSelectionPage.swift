import SwiftUI

struct StationSelectionPage: View {
    var body: some View {
        VStack(spacing: 20) {
            StoryListView(viewModel: .init())
            StationSelector()
            Spacer()
        }
    }
}

#Preview {
    StationSelectionPage()
}
