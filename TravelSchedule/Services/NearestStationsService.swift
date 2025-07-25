typealias NearestStations = Components.Schemas.NearestStationsResponse

protocol NearestStationsServiceProtocol {
    func getNearestStations(
        lat: Double,
        lng: Double,
        distance: Double,
        offset: Int?,
        limit: Int?

    ) async throws -> NearestStations
}

actor NearestStationsService: NearestStationsServiceProtocol {
    private let client: Client
    private let apikey: String
        
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestStations(
        lat: Double,
        lng: Double,
        distance: Double,
        offset: Int?,
        limit: Int?
    ) async throws -> NearestStations {
        try await client.getNearestStations(
            query: .init(
                apikey: apikey,
                lat: lat,
                lng: lng,
                distance: distance,
                offset: offset,
                limit: limit
            )
        ).ok.body.json
    }
}
