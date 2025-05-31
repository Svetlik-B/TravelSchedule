import OpenAPIURLSession

typealias CarrierInformation = Components.Schemas.CarrierInformationResponse

protocol CarrierInformationServiceProtocol {
    func getCarrierInformation(code: String) async throws -> CarrierInformation
    func getCarrierInformation(code: String, system: String?) async throws -> CarrierInformation
}

final class CarrierInformationService: CarrierInformationServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getCarrierInformation(code: String) async throws -> CarrierInformation {
        try await getCarrierInformation(code: code, system: nil)
    }

    func getCarrierInformation(
        code: String,
        system: String? = nil
    ) async throws -> CarrierInformation {
        try await client.getCarrierInformation(
            query: .init(
                apikey: apikey,
                code: code,
                system: system
            )
        ).ok.body.json
    }
}
