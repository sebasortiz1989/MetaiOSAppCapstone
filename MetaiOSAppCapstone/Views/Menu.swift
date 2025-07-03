//
//  Menu.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 02/07/25.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        VStack {
            Text("Little Lemon Menu")
                .foregroundColor(.black)
                .font(Font.system(size: 32, weight: .bold))
                .padding()

            Text("Chicago")
                .foregroundColor(.black)
                .font(Font.system(size: 32, weight: .bold))
                .padding()

            Text("Short description of the whole application.")
                .foregroundColor(.black)
                .font(Font.system(size: 24, weight: .regular))
                .padding()

            List {
                Text("Dish 1")
                Text("Dish 2")
                Text("Dish 3")
            }
        }
    }
}

#Preview {
    Menu()
}
