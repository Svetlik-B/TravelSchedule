import SwiftUI

struct UserAgreementView: View {
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
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    UserAgreementView()
}
