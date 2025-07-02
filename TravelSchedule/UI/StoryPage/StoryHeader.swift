import SwiftUI

struct StoryHeader: View {
    var progress: [CustomProgressBarViewModel]
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            HStack {
                ForEach(Array(progress.enumerated()), id: \.0) {
                    CustomProgressBar(viewModel: $0.1)
                }
            }
            Button {
                dismiss()
            } label: {
                Image(uiImage: .close)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    StoryHeader(
        progress: [
            .init(value: 0.5, isCompleted: true),
            .init(value: 0.5),
            .init()
        ]
    )
        .border(.white)
}
