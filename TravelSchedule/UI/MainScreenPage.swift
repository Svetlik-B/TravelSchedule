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

struct CitySelectionModal: View {
    @Binding var direction: String?
    @Binding var showCitySelector: Bool
    var body: some View {
        NavigationStack {
            CitySearchPage(
                viewModel: .mock(
                    onStationSelected: { city, station in
                        direction = "\(city.name) (\(station.name))"
                        showCitySelector = false
                    }
                )
            )
            .customNavigationBar(title: "Выбор города") {
                showCitySelector = false
            }
        }
    }
}

#Preview {
    MainScreenPage()
}
