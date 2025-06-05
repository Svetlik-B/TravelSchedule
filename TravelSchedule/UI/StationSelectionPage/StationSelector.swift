import SwiftUI

struct StationSelector: View {
    @State private var showFromCitySelector: Bool = false
    @State private var showToCitySelector: Bool = false
    @State private var showCarriers: Bool = false
    @State private var from: String?
    @State private var to: String?
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 18) {
                VStack(spacing: 26) {
                    DirectionButton(text: from, prompt: "Откуда") { showFromCitySelector = true }
                    DirectionButton(text: to, prompt: "Куда") { showToCitySelector = true }
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
                CustomButton(text: "Найти", hasDot: false) {
                    showCarriers = true
                }
                .frame(width: 150)
            }
        }
        .fullScreenCover(isPresented: $showCarriers) {
            CarrierListWrapper(from: from ?? "", to: to ?? "")
                .environment(\.colorScheme, colorScheme)
        }
        .fullScreenCover(isPresented: $showFromCitySelector) {
            CitySelectionModal(
                direction: $from,
                showCitySelector: $showFromCitySelector
            )
            .environment(\.colorScheme, colorScheme)
        }
        .fullScreenCover(isPresented: $showToCitySelector) {
            CitySelectionModal(
                direction: $to,
                showCitySelector: $showToCitySelector
            )
            .environment(\.colorScheme, colorScheme)
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

    struct CarrierListWrapper: View {
        var from: String
        var to: String
        @Environment(\.dismiss) private var dismiss
        var body: some View {
            NavigationStack {
                CarrierListPage(
                    viewModel: .init(
                        text: "\(from) -> \(to)",
                        carriers: mockCarriers,
                        hasFilter: true
                    )
                )
                .customNavigationBar(title: "") { dismiss() }
            }
        }
    }

    struct DirectionButton: View {
        var text: String?
        var prompt: String
        var action: () -> Void
        var body: some View {
            Button(action: action) {
                HStack {
                    Text(text ?? prompt)
                        .foregroundStyle(text == nil ? Color(uiColor: .lightGray) : .black)
                        .lineLimit(1)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    StationSelector()
}
