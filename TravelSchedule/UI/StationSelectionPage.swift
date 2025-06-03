import SwiftUI

struct StationSelectionPage: View {
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

            if true {  // from != nil && to != nil {
                CustomButton(text: "Найти", hasDot: true) {}
                    .padding(.horizontal, 50)
            }
        }
    }
}

struct CitySelectionModal: View {
    @Binding var from: String?
    @Binding var to: String?
    @Binding var showCitySelector: Bool
    var body: some View {
        NavigationStack {
            CitySearchPage(
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

