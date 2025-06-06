import Observation
import SwiftUI

@main
struct TravelScheduleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
//            MainScreenPage()
        }
    }
}

extension EnvironmentValues {
    @Entry var travelScheduleIsDarkBinding: Binding<Bool> = .constant(true)
}

enum Constant {
    static let apiKey = "65364b60-01c8-4836-9d57-47eff3a54212"
}
