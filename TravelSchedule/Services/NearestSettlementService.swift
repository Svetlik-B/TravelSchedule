typealias NearestSettlement = Components.Schemas.NearestSettlementResponse

protocol NearestSettlementServiceProtocol {
    func getNearestSettlement(
        lat: Double,
        lng: Double,
        distance: Double?
    ) async throws -> NearestSettlement
}

actor NearestSettlementService: NearestSettlementServiceProtocol {
    private let client: Client
    private let apikey: String
        
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestSettlement(
        lat: Double,
        lng: Double,
        distance: Double?
    ) async throws -> NearestSettlement {
        try await client.getNearestSettlement(
            query: .init(
                apikey: apikey,
                lat: lat,
                lng: lng,
                distance: distance
            )
        ).ok.body.json
    }
}
