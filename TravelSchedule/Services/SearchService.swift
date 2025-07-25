import Foundation

typealias Search = Components.Schemas.SearchResponse

protocol SearchProtocol {
    func getSearch(
        from: String,
        to: String,
        date: Date,
        transfers: Bool,
        offset: Int?,
        limit: Int?

    ) async throws -> Search
}

actor SearchService: SearchProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getSearch(
        from: String,
        to: String,
        date: Date,
        transfers: Bool,
        offset: Int?,
        limit: Int?
    ) async throws -> Search {
        let dateString = String(date.ISO8601Format().prefix(10))
        return try await client.getSearch(
            query: .init(
                apikey: apikey,
                from: from,
                to: to,
                date: dateString,
                transfers: transfers,
                offset: offset,
                limit: limit
            )
        ).ok.body.json
    }
}
