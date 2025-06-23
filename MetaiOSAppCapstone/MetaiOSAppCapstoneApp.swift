//
//  MetaiOSAppCapstoneApp.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 23/06/25.
//

import SwiftUI

@main
struct MetaiOSAppCapstoneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
