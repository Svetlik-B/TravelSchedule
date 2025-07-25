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

    @Published var carriers = [CarrierCardViewModel]()
    @Published var isLoading = false
    @Published var filterIsShown: Bool = false
    @Published var isCarrierInfoPageShown = false
    @Published var carrierCodeToShow: Int?
    private var filters: CarrierFilterPageViewModel.Filters = .init()
    private let iso8601DateFormatter = ISO8601DateFormatter()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter
    }()
}

extension CarrierListPageViewModel {
    var filteredCarriers: [CarrierCardViewModel] {
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
            dismissOnError(error)
        }
    }

    func dismissOnError(_ error: Error) {
        dismiss()
        onError(error)
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
            let code =
                segment.thread?.carrier?.code
                ?? segment.details?.compactMap(
                    \.thread?.carrier?.code
                ).first

            return CarrierCardViewModel(
                code: code,
                comment: comment,
                date: dateString,
                departure: String(departure ?? ""),
                duration: duration,
                arrival: String(arrival ?? ""),
                onError: onError
            )
        }
    }
    func showCarrierInfoPage(carrier: CarrierCardViewModel) {
        carrierCodeToShow = carrier.code
        isCarrierInfoPageShown = true
    }
}

struct CarrierListPage: View {
    @ObservedObject var viewModel: CarrierListPageViewModel
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            Text(viewModel.text).b24.padding()
            if viewModel.isLoading {
                Color.clear.overlay { Loader() }
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
                            .onTapGesture { viewModel.showCarrierInfoPage(carrier: carrier) }
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
        .fullScreenCover(isPresented: $viewModel.isCarrierInfoPageShown) {
            CarrierInfoPageWrapper(
                code: viewModel.carrierCodeToShow,
                onError: viewModel.dismissOnError
            )
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
    var code: Int?
    var onError: (Error) -> Void
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            CarrierInfoPage(
                viewModel: CarrierInfoPageViewModel(code: code, onError: onError)
            )
            .customNavigationBar(
                title: "Информация о перевозчике",
                action: { dismiss() }
            )
        }
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
