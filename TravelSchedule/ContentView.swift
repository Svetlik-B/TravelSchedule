import OpenAPIURLSession
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
        .task {
            do {
                try await checkSearchService()
//                try await checkScheduleService()
//                try await checkThreadServiceService()
//                try await checkNearestStationsService()
//                try await checkNearestSettlementService()
//                try await checkCarrierInformationService()
//                try await checkAllStationsService()
//                try await checkCopyrightService()
            } catch {
                print(error)
            }
        }
    }
}

func checkSearchService() async throws {
    print("\nSearchService...")
    let service = SearchService(
        client: Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        ),
        apikey: Constant.apiKey
    )
    let response = try await service.getSearch(
        from: "c146",
        to: "c213",
        offset: 0,
        limit: 1
    )
    print("SearchService response:")
    print(response)
}

func checkScheduleService() async throws {
    print("\nScheduleService...")
    let service = ScheduleService(
        client: Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        ),
        apikey: Constant.apiKey
    )
    let response = try await service.getSchedule(
        station: "s9600213",
        date: nil
    )
    print("ScheduleService response:")
    print(response)
}

func checkThreadServiceService() async throws {
    print("\nThreadService...")
    let service = ThreadService(
        client: Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        ),
        apikey: Constant.apiKey
    )
    let response = try await service.getThread(
        uid: "SU-1562_251027_c26_12",
        from: nil,
        to: nil,
        date: nil
    )
    print("ScheduleService response:")
    print(response)
}

func checkNearestStationsService() async throws {
    print("\nNearestStationsService...")
    let service = NearestStationsService(
        client: Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        ),
        apikey: Constant.apiKey
    )
    let response = try await service.getNearestStations(
        lat: 50.440046,
        lng: 40.4882367,
        distance: 50,
        offset: 0,
        limit: 1
    )
    print("NearestStationsService response:")
    print(response)
}

func checkNearestSettlementService() async throws {
    print("\nNearestSettlementService...")
    let service = NearestSettlementService(
        client: Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        ),
        apikey: Constant.apiKey
    )
    let response = try await service.getNearestSettlement(
        lat: 50.440046,
        lng: 40.4882367,
        distance: 50
    )
    print("NearestSettlementService response:")
    print(response)
}

func checkCarrierInformationService() async throws {
    print("\nCarrierInformationService...")
    let service = CarrierInformationService(
        client: Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        ),
        apikey: Constant.apiKey
    )
    let response = try await service.getCarrierInformation(code: "680")
    print("CarrierInformationService response:")
    print(response)
}

func checkAllStationsService() async throws {
    print("\nAllStationsService...")
    let service = AllStationsService(
        client: Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        ),
        apikey: Constant.apiKey
    )
    let response = try await service.getAllStations()
    print("AllStationsService response:")
    print(response.countries?.count as Any)
}

func checkCopyrightService() async throws {
    print("\nCopyrightService...")
    let service = CopyrightService(
        client: Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        ),
        apikey: Constant.apiKey
    )
    let response = try await service.getCopyright()
    print("CopyrightService response:")
    print(response)
}

#Preview {
    ContentView()
}
