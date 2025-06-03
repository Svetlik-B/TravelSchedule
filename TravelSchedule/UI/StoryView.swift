import SwiftUI

struct StoryView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                Spacer(minLength: 4)
                Image(uiImage: .Content._1.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._2.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._3.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._4.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._5.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._6.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._7.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._8.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._9.small)
                    .cornerRadius(12)
                Spacer(minLength: 4)
            }
            .frame(height: 188)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    StoryView()
}
