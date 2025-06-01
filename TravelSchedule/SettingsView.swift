import SwiftUI

struct SettingsView: View {
    @Binding var isDarkModeEnabled: Bool
    @State private var showUserAgreement: Bool = false
    var body: some View {
        VStack {
            List {
                Toggle("Темная тема", isOn: $isDarkModeEnabled)
                    .tint(.blue)
                    .listRowSeparator(Visibility.hidden)
                HStack {
                    Text("Пользовательское соглашение")
                    Spacer()
                    Image(uiImage: .chevron)
                        .renderingMode(.template)
                        .foregroundStyle(.primary)
                }
                .listRowSeparator(Visibility.hidden)
                .onTapGesture { showUserAgreement = true }
            }
            .listStyle(.plain)
            .listRowSpacing(16)
            VStack(spacing: 16) {
                Text("Приложение использует API «Яндекс.Расписания»")
                Text("Версия 1.0 (beta)")
            }.font(.system(size: 12))
            Divider()
        }
        .fullScreenCover(isPresented: $showUserAgreement) {
            UserAgreementView()
        }
    }
}

#Preview {
    SettingsView(isDarkModeEnabled: .constant(true))
}
