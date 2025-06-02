import SwiftUI

extension View {
    func standardNavigationBar(
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
