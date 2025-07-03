import Foundation

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class AllStationsService: AllStationsServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))

        let responseBody = try response.ok.body.html

        let limit = 50 * 1024 * 1024  // 50Mb
        let fullData = try await Data(collecting: responseBody, upTo: limit)

        let allStations = try JSONDecoder().decode(AllStations.self, from: fullData)

        return allStations
    }
    
    func getAllCities() async throws -> [City] {
        let allStations = try await getAllStations()
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
//            .filter { $0.station_type == "train_station"}
            .map {($0.codes?.yandex_code, $0.title) }
            .compactMap { (code, title) -> Station? in
                guard let code, let title
                else { return nil }
                return Station(id: code, name: title)
            }
    }
}
