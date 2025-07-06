//
//  ContentView.swift
//  DexCoreData
//
//  Created by Sebastian Ortiz on 04/07/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest<Pokemon>(
        sortDescriptors: [SortDescriptor(\.id)],
        animation: .default,
    ) private var pokedex
    
    @State private var searchText: String = ""
    
    let fetcher = FetchService()
    
    private var dynamicPredicate: NSPredicate {
        var predicates: [NSPredicate] = []
        
        // Search predicate
        if (!searchText.isEmpty) {
            predicates.append(NSPredicate(format: "name contains[c] %@", searchText))
        }
        
        // Filter by favorite predicate
        
        // Combine predicates
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink(value: pokemon) {
                        HStack {
                            AsyncImage(url: pokemon.sprite) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Text("\(pokemon.id)")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 12))
                                                .fontWeight(.bold)
                                        )
                                    Text(pokemon.name!.capitalized)
                                        .fontWeight(.bold)
                                }
                                
                                HStack {
                                    ForEach(pokemon.types!, id: \.self) { type in
                                        Text(type.capitalized)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                            .padding(.horizontal, 13)
                                            .padding(.vertical, 5)
                                            .background(Color(type.capitalized))
                                            .clipShape(.capsule)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pokedex")
            .searchable(text: $searchText, prompt: "Find a Pokemon")
            .autocorrectionDisabled()
            .onChange(of: searchText) {
                pokedex.nsPredicate = dynamicPredicate
            }
            .navigationDestination(for: Pokemon.self) { pokemon in
                Text(pokemon.name ?? "no name")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") {
                        getPokemon()
                    }
                }
            }
        }
    }
    
    private func getPokemon() {
        Task {
            for id in 1...151 {
                do {
                    let fetchedPokemon = try await fetcher.fetchPokemons(id)
                    let pokemon = Pokemon(context: viewContext)
                    
                    pokemon.id = fetchedPokemon.id
                    pokemon.name = fetchedPokemon.name
                    pokemon.types = fetchedPokemon.types
                    pokemon.hp = fetchedPokemon.hp
                    pokemon.attack = fetchedPokemon.attack
                    pokemon.defense = fetchedPokemon.defense
                    pokemon.specialAttack = fetchedPokemon.specialAttack
                    pokemon.specialDefense = fetchedPokemon.specialDefense
                    pokemon.speed = fetchedPokemon.speed
                    pokemon.sprite = fetchedPokemon.sprite
                    pokemon.shinySprite = fetchedPokemon.shinySprite
                    
                    try viewContext.save()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
