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
                List {
                    ForEach(filteredItems) { item in
                        NavigationLink {
                            ItemDetailView(item: item)
                        } label: {
                            ItemRowView(item: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .searchable(text: $searchText, prompt: "Search menu items...")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
    
    private var filteredItems: [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
        
        if !searchText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "timestamp CONTAINS[cd] %@", searchText)
        }
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching filtered items: \(error)")
            return []
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredItems[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ItemRowView: View {
    let item: Item
    
    var body: some View {
        HStack {
            Text(item.timestamp!, formatter: itemFormatter)
            Spacer()
            // You can add more details here if Item has more properties
        }
    }
}

struct ItemDetailView: View {
    let item: Item
    
    var body: some View {
        VStack {
            Text("Item Details")
            Text("Timestamp: \(item.timestamp!, formatter: itemFormatter)")
            // Add more details here
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
