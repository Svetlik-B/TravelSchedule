import SwiftUI

@Observable
final class SettingsPageViewModel {
    init(
        colorScheme: ColorScheme,
        showUserAgreement: Bool,
        setColorScheme: @escaping (ColorScheme) -> Void = { _ in }
    ) {
        self.colorScheme = colorScheme
        self.setColorScheme = setColorScheme
        self.showUserAgreement = showUserAgreement
        self.isDark = colorScheme == .dark
    }
    var isDark: Bool {
        didSet {
            colorScheme = isDark ? .dark : .light
            setColorScheme(colorScheme)
        }
    }
    var colorScheme: ColorScheme
    var setColorScheme: (ColorScheme) -> Void
    var showUserAgreement: Bool
}

struct SettingsPage: View {
    @Bindable var viewModel: SettingsPageViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            List {
                Toggle("Темная тема", isOn: $viewModel.isDark)
                    .tint(.blue)
                    .listRowSeparator(Visibility.hidden)
                HStack {
                    Text("Пользовательское соглашение")
                    Spacer()
                    Image(uiImage: .Chevron.right)
                        .renderingMode(.template)
                        .foregroundStyle(.primary)
                }
                .listRowSeparator(Visibility.hidden)
                .onTapGesture { viewModel.showUserAgreement = true }
            }
            .listStyle(.plain)
            .listRowSpacing(16)
            VStack(spacing: 16) {
                Text("Приложение использует API «Яндекс.Расписания»")
                Text("Версия 1.0 (beta)")
            }.r12
        }
        .fullScreenCover(isPresented: $viewModel.showUserAgreement) {
            NavigationStack {
                UserAgreementView()
                    .customNavigationBar(
                        title: "Пользовательское соглашение",
                        action: { viewModel.showUserAgreement = false }
                    )
            }
            .environment(\.colorScheme, viewModel.colorScheme)
        }
    }
}

#Preview {
    SettingsPage(
        viewModel: .init(
            colorScheme: .dark,
            showUserAgreement: false
        )
    )
}
