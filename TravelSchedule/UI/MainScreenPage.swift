import SwiftUI

struct MainScreenPage: View {
    @State private var showCitySelector: Bool = false
    @State private var from: String?
    @State private var to: String?
    @Environment(\.colorScheme) var colorScheme
    @State private var isDark = true
    var body: some View {
        TabView {
            VStack {
                StationSelectionPage(
                    from: $from,
                    to: $to,
                    showCitySelector: $showCitySelector
                )
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
        .fullScreenCover(isPresented: $showCitySelector) {
            CitySelectionModal(
                from: $from,
                to: $to,
                showCitySelector: $showCitySelector
            )
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
        .environment(\.travelScheduleIsDarkBinding, $isDark)
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}

#Preview {
    MainScreenPage()
}
