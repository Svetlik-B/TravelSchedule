typealias Search = Components.Schemas.SearchResponse

protocol SearchProtocol {
    func getSearch(
        from: String,
        to: String,
        offset: Int?,
        limit: Int?

    ) async throws -> Search
}

final class SearchService: SearchProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getSearch(
        from: String,
        to: String,
        offset: Int?,
        limit: Int?
    ) async throws -> Search {
        try await client.getSearch(
            query: .init(
                apikey: apikey,
                from: from,
                to: to,
                offset: offset,
                limit: limit
            )
        ).ok.body.json
    }
}
