import SwiftUI

extension View {
    func customNavigationBar(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: action) {
                        Image(uiImage: .Chevron.left)
                            .renderingMode(.template)
                            .tint(.primary)
                    }
                }
            }
    }
}
