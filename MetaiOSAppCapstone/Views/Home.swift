//
//  Home.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 02/07/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            Menu()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
