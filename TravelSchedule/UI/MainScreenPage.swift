import SwiftUI

struct MainScreenPage: View {
    @State private var showFromCitySelector: Bool = false
    @State private var showToCitySelector: Bool = false
    @State private var from: String?
    @State private var to: String?
    @Environment(\.colorScheme) var colorScheme
    @State private var isDark = true
    var body: some View {
        TabView {
            VStack {
                StationSelectionPage(
                    viewModel: .init(
                        from: $from,
                        to: $to,
                        showFromCitySelector: $showFromCitySelector,
                        showToCitySelector: $showToCitySelector
                    )
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
        .fullScreenCover(isPresented: $showFromCitySelector) {
            CitySelectionModal(
                direction: $from,
                showCitySelector: $showFromCitySelector
            )
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
        .fullScreenCover(isPresented: $showToCitySelector) {
            CitySelectionModal(
                direction: $to,
                showCitySelector: $showToCitySelector
            )
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
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
