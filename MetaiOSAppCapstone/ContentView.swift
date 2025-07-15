//
//  ContentView.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 23/06/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .searchable(text: $searchText, prompt: "Search menu items...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addDish) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .navigationTitle("Menu")
    }
    
    private func addDish() {
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    struct DishRowView: View {
        let item: Dish
        
        var body: some View {
            HStack {
                Text(item.name!)
                Spacer()
                // You can add more details here if Item has more properties
            }
        }
    }
    
    struct DishDetailView: View {
        let item: Dish
        
        var body: some View {
            VStack {
                Text("Item Details")
                Text("Timestamp: \(item.name ?? "default value")")
                // Add more details here
            }
        }
    }
}

#Preview {
    ContentView()
}
