import SwiftUI

@main
struct LittleLemonRestaurantApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
