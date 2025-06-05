import SwiftUI

struct MainScreenPage: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isDark = true
    var body: some View {
        TabView {
            VStack {
                StationSelectionPage()
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .schedule)
            }
            VStack {
                SettingsPage()
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .settings)
            }
        }
        .tint(.primary)
        .environment(\.travelScheduleIsDarkBinding, $isDark)
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}

#Preview {
    MainScreenPage()
}
