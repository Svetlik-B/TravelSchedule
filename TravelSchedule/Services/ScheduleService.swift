typealias Schedule = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getSchedule(
        station: String,
        date: String?
    ) async throws -> Schedule
}

final class ScheduleService: ScheduleServiceProtocol {
    private let client: Client
    private let apikey: String
        
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getSchedule(
        station: String,
        date: String?
    ) async throws -> Schedule {
        try await client.getSchedule(
            query: .init(
                apikey: apikey,
                station: station,
                date: date
            )
        ).ok.body.json
    }
}
