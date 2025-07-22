import OpenAPIURLSession
import OpenAPIRuntime
import SwiftUI

struct CarrierListPage: View {
    @Observable
    @MainActor
    final class ViewModel: @preconcurrency Identifiable {
        var id: String { from.id + "-" + to.id }
        var from: Station
        var to: Station
        var carriers = [CarrierCard.ViewModel]()
        var hasFilter = false

        func updateCarriers() async throws {
            let service = try SearchService(
                client: Client(serverURL: Servers.Server1.url(), transport: URLSessionTransport()),
                apikey: Constant.apiKey
            )
            print("from:", from)
            print("to:", to)
            let result = try await service.getSearch(
                from: from.id,
                to: to.id,
                date: Date(),
                transfers: true,
                offset: nil,
                limit: nil
            )

            // TODO: logo
            // TODO: mock
            // TODO: filter
            // TODO: more then 100

            let segments = result.segments ?? []
            carriers = segments.compactMap { segment in
                var duration =
                    segment.duration ?? segment.details?.compactMap(\.duration).reduce(0, +) ?? 0

                duration /= 60 * 60

                let departure = (segment.departure ?? "???").prefix(11 + 5).suffix(5)
                let arrival = (segment.arrival ?? "???").prefix(11 + 5).suffix(5)
                var comment: String?
                if let transfers = segment.transfers, !transfers.isEmpty {
                    let stations = transfers.compactMap(\.title).joined(separator: ", ")
                    comment = "С пересадкой (\(stations))"
                }
                var dateString = "No Date"
                if let departureDate = segment.departure,
                    let date = ISO8601DateFormatter().date(from: departureDate)
                {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d MMMM"
                    dateString = dateFormatter.string(from: date)
                }
                let id = [segment.departure, segment.arrival]
                    .compactMap { $0 }
                    .joined(separator: " -> ")

                let name =
                    segment.thread?.carrier?.title ?? segment.details?.compactMap(
                        \.thread?.carrier?.title
                    ).first ?? "No Name 22"

                return CarrierCard.ViewModel(
                    id: id,
                    name: name,
                    comment: comment,
                    date: dateString,
                    departure: String(departure),
                    duration: duration,
                    arrival: String(arrival)
                )
            }

        }

        var text: String {
            "\(from.name) -> \(to.name)"
        }

        init(
            from: Station,
            to: Station
        ) {
            self.from = from
            self.to = to
        }
    }
    let viewModel: ViewModel
    @State private var isLoading = false
    @State private var filterIsShown: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.onError) private var onError
    var body: some View {
        VStack {
            Text(viewModel.text).b24
                .padding()
            if isLoading {
                Color.clear.overlay { ProgressView() }
            } else if viewModel.carriers.isEmpty {
                NotFoundView(text: "Вариантов нет")
                    .offset(y: -CustomButton.Constant.height)
            } else {
                List {
                    ForEach(viewModel.carriers) { carrier in
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
                    ) { filterIsShown = true }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $filterIsShown) {
            CarrierFilterPageWrapper()
                .environment(\.colorScheme, colorScheme)
        }
        .task {
            isLoading = true
            do {
                try await viewModel.updateCarriers()
                isLoading = false
            } catch {
                dismiss()
                guard
                    let error = error as? ClientError,
                    error.causeDescription == "Transport threw an error."
                else {
                    onError(ErrorKind.server)
                    return
                }
                onError(ErrorKind.internet)

            }
        }
    }
}

struct CarrierFilterPageWrapper: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        let viewModel: CarrierFilterPageViewModel = {
            let viewModel = CarrierFilterPageViewModel()
            viewModel.proceed = { dismiss() }
            return viewModel
        }()
        NavigationStack {
            CarrierFilterPage(viewModel: viewModel)
                .customNavigationBar(title: "") {
                    dismiss()
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
                to: .init(id: "s2000003", name: "Москва (Казанский вокзал)")
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
