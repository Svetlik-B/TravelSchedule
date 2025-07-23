import SwiftUI

@MainActor
final class SettingsPageViewModel: ObservableObject {
    var onError: (Error) -> Void = { _ in }
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
    @Published var isDark: Bool {
        didSet {
            colorScheme = isDark ? .dark : .light
            setColorScheme(colorScheme)
        }
    }
    @Published var colorScheme: ColorScheme
    @Published var showUserAgreement: Bool
    var setColorScheme: (ColorScheme) -> Void
}

struct SettingsPage: View {
    @ObservedObject var viewModel: SettingsPageViewModel
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
                UserAgreementView(onError: viewModel.onError)
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
        ) { print("error:", $0) }
    )
}
