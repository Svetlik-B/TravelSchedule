import Observation
import SwiftUI

@main
struct TravelScheduleApp: App {
    @State private var isDark = true
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.travelScheduleIsDarkBinding, $isDark)
                .environment(\.colorScheme, isDark ? .dark : .light)
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .onChange(of: isDark) { print("Color scheme changed to: \($0 ? "Dark" : "Light")")}
    }
}

extension EnvironmentValues {
    @Entry var travelScheduleIsDarkBinding: Binding<Bool> = .constant(true)
}

enum Constant {
    static let apiKey = "65364b60-01c8-4836-9d57-47eff3a54212"
}
