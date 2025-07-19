//
//  Home.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 02/07/25.
//

import SwiftUI

struct Home: View {
    let persistenceController = PersistenceController.shared

    var body: some View {
        TabView {
            Menu()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            UserProfile()
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
