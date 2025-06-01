import SwiftUI

struct MainScreen: View {
    @State var isDarkModeEnabled: Bool = false
    var body: some View {
        TabView {
            VStack {
                Text("Расписание")
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .schedule)
            }
            SettingsView(isDarkModeEnabled: $isDarkModeEnabled)
                .tabItem {
                    Image(uiImage: .settings)
                }
        }
        .tint(.primary)
        .environment(
            \.colorScheme,
            isDarkModeEnabled ? .dark : .light
        )
    }
}

#Preview {
    MainScreen()
}
