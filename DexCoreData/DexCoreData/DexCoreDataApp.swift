//
//  DexCoreDataApp.swift
//  DexCoreData
//
//  Created by Sebastian Ortiz on 04/07/25.
//

import SwiftUI

@main
struct DexCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
