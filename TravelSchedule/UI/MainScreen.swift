import SwiftUI

struct MainScreen: View {
    @State private var showCitySelector: Bool = false
    @State private var from: String?
    @State private var to: String?
    @Environment(\.colorScheme) var colorScheme
    @State private var isDark = true
    var body: some View {
        TabView {
            VStack {
                StationSelectionView(
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
                SettingsView()
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
    MainScreen()
}

struct StationSelector: View {
    @Binding var from: String?
    @Binding var to: String?
    @Binding var showCitySelector: Bool
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 18) {
                VStack(spacing: 26) {
                    Button {
                        showCitySelector = true
                    } label: {
                        HStack {
                            if let from {
                                Text(from)
                            } else {
                                Text("Откуда")
                                    .foregroundStyle(Color(uiColor: .lightGray))
                            }
                            Spacer()
                        }
                    }
                    HStack {
                        if let to {
                            Text(to)
                        } else {
                            Text("Куда")
                                .foregroundStyle(Color(uiColor: .lightGray))
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                Button {
                    (from, to) = (to, from)
                } label: {
                    Image(uiImage: .сhange)
                        .padding(5)
                        .background(.white)
                        .cornerRadius(100)
                }
            }
            .padding()
            .background(Color.Colors.blueUniversal)
            .cornerRadius(16)
            .padding(.horizontal)

            if from != nil && to != nil {
                Button(action: {}) {
                    ZStack {
                        Color.Colors.blueUniversal
                        Text("Найти")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 150, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

struct StationSelectionView: View {
    @Binding var from: String?
    @Binding var to: String?
    @Binding var showCitySelector: Bool
    var body: some View {
        VStack(spacing: 20) {
            StoryView()
            StationSelector(
                from: $from,
                to: $to,
                showCitySelector: $showCitySelector
            )
        }
    }
}

struct CitySelectionModal: View {
    @Binding var from: String?
    @Binding var to: String?
    @Binding var showCitySelector: Bool
    var body: some View {
        NavigationStack {
            CitySearchView(
                viewModel: .mock(
                    onStationSelected: { city, station in
                        from = "\(city.name) (\(station.name))"
                        showCitySelector = false
                    }
                )
            )
            .standardNavigationBar(title: "Выбор города") {
                showCitySelector = false
            }
        }
    }
}
