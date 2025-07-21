import OpenAPIURLSession
import SwiftUI

struct CityLoader: Sendable {
    var loadCities: @Sendable () async throws -> [City]
}

// боевой загрузчик
extension CityLoader {
    static let live = CityLoader {
        let service = AllStationsService(
            client: Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            ),
            apikey: Constant.apiKey
        )
        let allStations = try await service.getAllStations()
        let filteredCountries = allStations.countries
            .filter { $0.title == "Россия"}
        
        return filteredCountries
            .flatMap(\.regions)
            .flatMap(\.cities)
    }
}

private extension Components.Schemas.Region {
    var cities: [City] {
        settlements
            .map {($0.codes?.yandex_code, $0.title, $0.trainStations)}
            .compactMap { code, title, stations -> City? in
                guard let code, let title, !stations.isEmpty
                else { return nil }
                return City(
                    id: code,
                    name: title,
                    stations: stations
                )
            }
    }
}

private extension Components.Schemas.Settlement {
    var trainStations: [Station] {
        stations
            .filter { $0.transport_type == "train"}
            .map {($0.codes?.yandex_code, $0.title) }
            .compactMap { (code, title) -> Station? in
                guard let code, let title
                else { return nil }
                return Station(id: code, name: title)
            }
    }
}


// тестовый загрузчик (перенести в тесты когда они появятся :)
extension CityLoader {
    static let mock = CityLoader {
        print("Используем тестовые данные!!!")
        return [
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
