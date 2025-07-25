typealias Thread = Components.Schemas.TreadResponse

protocol ThreadServiceProtocol {
    func getThread(
        uid: String,
        from: String?,
        to: String?,
        date: String?
    ) async throws -> Thread
}

actor ThreadService: ThreadServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getThread(
        uid: String,
        from: String?,
        to: String?,
        date: String?
    ) async throws -> Thread {
        try await client.getThread(
            query: .init(
                apikey: apikey,
                uid: uid,
                from: from,
                to: to,
                date: date
            )
        ).ok.body.json
    }
}
