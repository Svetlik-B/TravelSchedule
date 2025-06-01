import SwiftUI

struct UserAgreementView: View {
    var isDark: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ScrollView{
            VStack {
                ZStack {
                    Text("Пользовательское соглашение")
                    HStack {
                        Button{
                            dismiss()
                        } label: {
                            Image(uiImage: .Chevron.left)
                                .renderingMode(.template)
                                .tint(.primary)
                        }
                        .padding()
                        Spacer()
                    }

                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(isDark ? Color.black : Color.white)
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}

#Preview("Dark") {
    UserAgreementView(isDark: false)
}
#Preview("Light") {
    UserAgreementView(isDark: true)
}
