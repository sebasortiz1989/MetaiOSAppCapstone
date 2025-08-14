//
//  ContentView.swift
//  DexCoreData
//
//  Created by Sebastian Ortiz on 04/07/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pokemon.id, animation: .default) private var pokedex: [Pokemon]
    
    @State private var searchText: String = ""
    @State private var filterByFavorite: Bool = false
    
    let fetcher = FetchService()
    let totalNumberOfPokemons: Int = 151
    
    private var dynamicPredicate: NSPredicate {
        var predicates: [NSPredicate] = []
        
        // Search predicate
        if (!searchText.isEmpty) {
            predicates.append(NSPredicate(format: "name contains[c] %@", searchText))
        }
        
        // Filter by favorite predicate
        if filterByFavorite {
            predicates.append(NSPredicate(format: "favorite == %d", true))
        }
        
        // Combine predicates
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    var body: some View {
        if pokedex.isEmpty {
            ContentUnavailableView {
                Label("No Pokemon", image: .nopokemon)
            } description: {
                Text("There aren't any Pokemon yet. \nFetch some Pokemon to get started!")
            } actions: {
                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                    getPokemon(from: 1)
                }
                .buttonStyle(.borderedProminent)
            }
        } else {
            NavigationStack {
                List {
                    Section {
                        ForEach(pokedex) { pokemon in
                            NavigationLink(value: pokemon) {
                                HStack {
                                    if (pokemon.sprite == nil) {
                                        AsyncImage(url: pokemon.spriteURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 100)
                                    } else {
                                        pokemon.spriteImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    }
            
                                    
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
                                            Text(pokemon.name.capitalized)
                                                .fontWeight(.bold)
                                            
                                            Spacer()
                                            
                                            if pokemon.favorite {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                        
                                        HStack {
                                            ForEach(pokemon.types, id: \.self) { type in
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
                            .swipeActions(edge: .leading) {
                                Button(pokemon.favorite ? "Remove from favorites" : "Add to favorites", systemImage: "star") {
                                    pokemon.favorite.toggle()
                                    
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print(error)
                                    }
                                }
                                .tint(pokemon.favorite ? .gray : .yellow)
                            }
                        }
                    } footer: {
                        if pokedex.count < totalNumberOfPokemons {
                            ContentUnavailableView {
                                Label("Missing Pokemon", image: .nopokemon)
                            } description: {
                                Text("The fetch was interrupted!\nFetch the rest of the Pokemon.")
                            } actions: {
                                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                                    getPokemon(from: pokedex.count + 1)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }

                }
                .navigationTitle("Pokedex")
                .searchable(text: $searchText, prompt: "Find a Pokemon")
                .autocorrectionDisabled()
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetail(pokemon: pokemon)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            filterByFavorite.toggle()
                        } label: {
                            Label("Filter By Favorites", systemImage: filterByFavorite ? "star.fill" :"star")
                        }
                        .tint(.yellow)
                    }
                }
            }
            //        .task {
            //            getPokemon()
            //        }
        }
    }
    
    private func getPokemon(from id: Int) {
        Task {
            for i in id...totalNumberOfPokemons {
                do {
                    let fetchedPokemon = try await fetcher.fetchPokemons(i)
                    modelContext.insert(fetchedPokemon)
                } catch {
                    print("Error: \(error)")
                }
            }

            storeSprintes();
        }
    }
    
    private func storeSprintes() {
        Task {
            do {
                for pokemon in pokedex {
                    pokemon.sprite = try await URLSession.shared.data(from: pokemon.spriteURL).0
                    pokemon.shiny = try await URLSession.shared.data(from: pokemon.shinyURL).0
                    
                    try modelContext.save()
                    
                    print("Sprites stored: \(pokemon.id): \(pokemon.name.capitalized)")
                }
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView().modelContainer(PersistenceController.preview)
}
