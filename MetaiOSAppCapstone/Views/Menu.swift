//
//  Menu.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 02/07/25.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var dishesModel = DishesModel()
    @State var searchText = ""
    @State private var menuItems: [MenuItem] = []

    @FetchRequest<Dish>(
        sortDescriptors: [SortDescriptor(\.name)],
        animation: .default,
    ) private var dishesT
    
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
     
            List(menuItems) { item in
                Text(item.title)
            }
        }
        .onAppear {
            Task {
                do {
                    menuItems = try await MenuList.getMenuData()
                } catch {
                    print("Error fetching menu: \(error)")
                }
            }
        }
    }
    
    private func buildPredicate() -> NSPredicate {
        return searchText == "" ?
        NSPredicate(value: true) :
        NSPredicate(format: "name CONTAINS[cd] %@", searchText)
    }
}

#Preview {
    Menu()
}
