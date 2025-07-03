import Observation
import OpenAPIURLSession

struct City: Identifiable, Equatable, Hashable, Codable {
    var id: String
    var name: String
    var stations: [Station]
}
struct Station: Identifiable, Equatable, Hashable, Codable {
    var id: String
    var name: String
}

struct CityLoader {
    var loadCities: () async throws -> [City]
    static var live = Self {
        let service = AllStationsService(
            client: Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            ),
            apikey: Constant.apiKey
        )
        return try await service.getAllCities()
    }
    static var mock: Self {
        .init {
            [
                .init(
                    id: "1",
                    name: "Москва",
                    stations: [
                        .init(id: "1_1", name: "Киевский вокзал"),
                        .init(id: "1_2", name: "Курский вокзал"),
                        .init(id: "1_3", name: "Ярославский вокзал"),
                        .init(id: "1_4", name: "Белорусский вокзал"),
                        .init(id: "1_5", name: "Савёловский вокзал"),
                        .init(id: "1_6", name: "Ленинградский вокзал"),
                    ]
                ),
                .init(
                    id: "2",
                    name: "Санкт Петербург",
                    stations: [
                        .init(id: "2_1", name: "Московский вокзал"),
                        .init(id: "2_2", name: "Ладожский вокзал"),
                        .init(id: "2_3", name: "Финляндский вокзал"),
                        .init(id: "2_4", name: "Витебский вокзал"),
                        .init(id: "2_5", name: "Балтийский вокзал"),
                    ]
                ),
                .init(id: "3", name: "Сочи", stations: []),
                .init(id: "4", name: "Горный Воздух", stations: []),
                .init(id: "5", name: "Краснодар", stations: []),
                .init(id: "6", name: "Казань", stations: []),
                .init(id: "7", name: "Омск", stations: []),
                .init(id: "8", name: "Ижевск", stations: []),
                .init(id: "9", name: "Иркутск", stations: []),
                .init(id: "10", name: "Саратов", stations: []),
            ]
        }
    }
}

@Observable
final class CitySearchViewModel {
    var searchText = ""
    private var fullList = [City]()

    var onStationSelected: (City, Station) -> Void

    init(onStationSelected: @escaping (City, Station) -> Void) {
        self.onStationSelected = onStationSelected
    }
}

// MARK: Interface
extension CitySearchViewModel {
    func city(id: String) -> City? {
        fullList.first(where: { $0.id == id })
    }
    var filteredCities: [City] {
        if searchText.isEmpty {
            return Self.shortListCitiesNames
                .compactMap { name in
                    fullList.first(where: { city in
                        city.name == name
                    })
                }
        } else {
            return fullList.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    func setFullList(cities: [City]) { fullList = cities }
}

extension CitySearchViewModel {
    fileprivate static let shortListCitiesNames: [String] = [
        "Москва",
        "Санкт-Петербург",
        "Сочи",  //??
        "Горный Воздух",  //??
        "Краснодар",  //??
        "Казань",
        "Омск",
    ]

}

extension CitySearchViewModel {
    static func live(
        onStationSelected: @escaping (City, Station) -> Void
    ) -> CitySearchViewModel {
        .init(
            onStationSelected: onStationSelected
        )
    }
}

extension CitySearchViewModel {
    static func mock(
        onStationSelected: @escaping (City, Station) -> Void
    ) -> CitySearchViewModel {
        .init(
            //            fullList: [
            onStationSelected: onStationSelected
        )
    }
}
