import OpenAPIRuntime
import OpenAPIURLSession
import SwiftUI

@MainActor
final class CarrierListPageViewModel: ObservableObject, Identifiable {
    let from: Station
    let to: Station
    let dismiss: () -> Void
    let onError: (Error) -> Void
    init(
        from: Station,
        to: Station,
        dismiss: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        self.from = from
        self.to = to
        self.dismiss = dismiss
        self.onError = onError
    }

    @Published var carriers = [CarrierCard.ViewModel]()
    @Published var isLoading = false
    @Published var filterIsShown: Bool = false
    private var filters: CarrierFilterPageViewModel.Filters = .init()
    private let iso8601DateFormatter = ISO8601DateFormatter()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter
    }()
}

extension CarrierListPageViewModel {
    var filteredCarriers: [CarrierCard.ViewModel] {
        carriers.filter { carrier in
            guard hasFilter
            else { return true }

            if filters.showWithTransfers == false && carrier.comment != nil {
                return false
            }

            if !filters.showMorning
                && !filters.showDay
                && !filters.showEvening
                && !filters.showNight
            {
                return true
            }

            guard
                let departureHourString = carrier.departure.split(separator: ":").first,
                let departureHour = Int(departureHourString)
            else { return true }

            if filters.showMorning && departureHour >= 6 && departureHour < 12 {
                return true
            }
            if filters.showDay && departureHour >= 12 && departureHour < 18 {
                return true
            }
            if filters.showEvening && departureHour >= 18 {
                return true
            }
            if filters.showNight && departureHour < 6 {
                return true
            }
            return false
        }
    }
    func showFilters() {
        filters = .init()
        filterIsShown = true
    }
    var hasFilter: Bool {
        filters.showMorning
            || filters.showDay
            || filters.showEvening
            || filters.showNight
            || filters.showWithTransfers != nil
    }

    var text: String {
        "\(from.name) -> \(to.name)"
    }
    var hasNoCarriers: Bool {
        filteredCarriers.isEmpty
    }
    func update() async {
        isLoading = true
        do {
            try await updateCarriers()
            isLoading = false
        } catch {
            onError(error)
            dismiss()
        }
    }

    func applyFilters(_ newFilters: CarrierFilterPageViewModel.Filters) {
        filters = newFilters
    }

    func updateCarriers() async throws {
        let service = try SearchService(
            client: Client(serverURL: Servers.Server1.url(), transport: URLSessionTransport()),
            apikey: Constant.apiKey
        )
        var result = try await service.getSearch(
            from: from.id,
            to: to.id,
            date: Date(),
            transfers: true,
            offset: nil,
            limit: 1
        )
        
        result = try await service.getSearch(
            from: from.id,
            to: to.id,
            date: Date(),
            transfers: true,
            offset: nil,
            limit: result.pagination?.total
        )

        // TODO: logo

        let segments = result.segments ?? []
        carriers = segments.compactMap { segment in
            var duration =
                segment.duration ?? segment.details?.compactMap(\.duration).reduce(0, +) ?? 0

            duration /= 60 * 60

            let departure = segment.departure?.prefix(11 + 5).suffix(5)
            let arrival = segment.arrival?.prefix(11 + 5).suffix(5)
            var comment: String?
            if let transfers = segment.transfers, !transfers.isEmpty {
                let stations = transfers.compactMap(\.title).joined(separator: ", ")
                comment = "С пересадкой (\(stations))"
            }
            var dateString = "No Date"
            if let departureDate = segment.departure,
                let date = iso8601DateFormatter.date(from: departureDate)
            {
                dateString = dateFormatter.string(from: date)
            }
            let id = [segment.departure, segment.arrival]
                .compactMap { $0 }
                .joined(separator: " -> ")

            let name =
                segment.thread?.carrier?.title ?? segment.details?.compactMap(
                    \.thread?.carrier?.title
                ).first ?? "No Name"

            return CarrierCard.ViewModel(
                id: id,
                name: name,
                comment: comment,
                date: dateString,
                departure: String(departure ?? ""),
                duration: duration,
                arrival: String(arrival ?? "")
            )
        }
    }

}

struct CarrierListPage: View {
    @ObservedObject var viewModel: CarrierListPageViewModel
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            Text(viewModel.text).b24.padding()
            if viewModel.isLoading {
                Color.clear.overlay { ProgressView() }
            } else if viewModel.hasNoCarriers {
                NotFoundView(text: "Вариантов нет")
                    .offset(y: -CustomButton.Constant.height)
                    .overlay(alignment: .bottom) {
                        if viewModel.hasFilter {
                            CustomButton(
                                text: "Уточнить время",
                                hasDot: viewModel.hasFilter
                            ) { viewModel.showFilters() }
                            .padding()
                        }
                    }
            } else {
                List {
                    ForEach(viewModel.filteredCarriers) { carrier in
                        CarrierCard(viewModel: carrier)
                            .listRowBackground(Color.clear)
                            .background {
                                NavigationLink("") {
                                    CarrierInfoPageWrapper()
                                }
                            }
                    }
                    Spacer().frame(height: CustomButton.Constant.height)
                }
                .listRowSpacing(8)
                .listStyle(.plain)
                .overlay(alignment: .bottom) {
                    CustomButton(
                        text: "Уточнить время",
                        hasDot: viewModel.hasFilter
                    ) { viewModel.showFilters() }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.filterIsShown) {
            CarrierFilterPageWrapper(isShown: $viewModel.filterIsShown) { filters in
                viewModel.applyFilters(filters)
            }
            .environment(\.colorScheme, colorScheme)
        }
        .task { await viewModel.update() }
    }
}

struct CarrierFilterPageWrapper: View {
    @Binding var isShown: Bool
    let action: (CarrierFilterPageViewModel.Filters) -> Void
    var body: some View {
        let viewModel = CarrierFilterPageViewModel { filters in
            action(filters)
            isShown = false
        }
        NavigationStack {
            CarrierFilterPage(viewModel: viewModel)
                .customNavigationBar(title: "") {
                    isShown = false
                }
        }
    }
}

struct CarrierInfoPageWrapper: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        let viewModel: CarrierInfoPage.ViewModel = {
            let viewModel = CarrierInfoPage.ViewModel.init(
                logo: nil,
                name: "ОАО «РЖД»",
                email: "I.Lozgkina@yandex.ru",
                phone: "+7 (904) 329-27-71"
            )
            return viewModel
        }()
        CarrierInfoPage(viewModel: viewModel)
            .customNavigationBar(
                title: "Информация о перевозчике",
                action: { dismiss() }
            )
    }
}

#Preview {
    NavigationStack {
        CarrierListPage(
            viewModel: .init(
                from: .init(id: "s9612140", name: "Ижевск"),
                to: .init(id: "s2000003", name: "Москва (Казанский вокзал)"),
                dismiss: {},
                onError: { print("error:", $0) }
            )
        )
    }
}

var mockCarriers: [CarrierCard.ViewModel] {
    makeIds(carriers: [
        .rzd,
        .fgk,
        .ural,
        .rzd,
        .fgk,
        .ural,
        .rzd,
        .fgk,
        .ural,
    ])
}

func makeIds(carriers: [CarrierCard.ViewModel]) -> [CarrierCard.ViewModel] {
    carriers.enumerated().map { index, carrier in
        carrier.with(id: "\(index)")
    }
}
