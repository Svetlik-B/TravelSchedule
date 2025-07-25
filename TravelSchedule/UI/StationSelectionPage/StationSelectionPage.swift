import SwiftUI

struct StationSelectionPage: View {
    var onError: (Error) -> Void
    var body: some View {
        VStack(spacing: 20) {
            StoryListView()
            StationSelector(viewModel: .init(onError: onError))
            Spacer()
        }
    }
}

#Preview {
    StationSelectionPage(onError: { print("error:", $0) })
}
