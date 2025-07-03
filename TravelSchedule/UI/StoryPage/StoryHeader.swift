import SwiftUI

struct StoryHeader: View {
    var progress: [Double]
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            HStack {
                ForEach(Array(progress.enumerated()), id: \.0) {
                    CustomProgressBar(value: $0.1)
                }
            }
            Button {
                dismiss()
            } label: {
                Image(uiImage: .close)
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
}

struct PinkBorderedProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .padding(4)
            .border(.pink, width: 3)
            .cornerRadius(4)
    }
}

#Preview {
    StoryHeader(progress: [1, 0.5, 0])
}
