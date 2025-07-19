import SwiftUI
import CoreData

struct Menu: View {
    let persistenceController = PersistenceController.shared

    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var dishesModel = DishesModel()
    @State var searchText = ""
    @State private var menuItems: [MenuItem] = []

    let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"

    @FetchRequest<Dish>(
        sortDescriptors: [SortDescriptor(\.title)],
        animation: .default
    ) private var dishesT
    
    private var dynamicPredicate: NSPredicate {
        var predicates: [NSPredicate] = []
        
        // Search predicate
        if (!searchText.isEmpty) {
            predicates.append(NSPredicate(format: "title contains[c] %@", searchText))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    var body: some View {
        VStack {    
            NavigationStack {
                List {
                    ForEach(dishesT) { dish in
                        NavigationLink(value: dish) {
                            HStack {
                                Text("\(dish.title ?? "No Title") - $\(String(format: "%.2f", dish.price))")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        Image(systemName: "photo")
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search a dish")
                .navigationDestination(for: Dish.self) { dish in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(dish.title ?? "No Title")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: 200)
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(maxWidth: .infinity, maxHeight: 200)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            Text(dish.dishDescription ?? "No Description")
                                .font(.body)
                            
                            Text("Price: $\(String(format: "%.2f", dish.price))")
                                .font(.headline)
                        }
                        .padding()
                    }
                    .navigationTitle(dish.title ?? "Dish Details")
                }
                .onChange(of: searchText) {
                    dishesT.nsPredicate = buildPredicate()
                }
            }

        }
        .onAppear {
            Task {
                if dishesT.isEmpty {
                    do {
                        menuItems = try await getMenuData()
                    } catch {
                        print("Error fetching menu: \(error)")
                    }
                }
            }
        }
    }
    
    enum FetchError: Error {
        case badResponse
        case invalidData
        case decodingError(Error)
    }

    func getMenuData() async throws -> [MenuItem] {
        persistenceController.clear()
        
        guard let baseURL = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest(url: baseURL)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw FetchError.badResponse
            }
            
            do {
                let fullMenu = try JSONDecoder().decode(JSONMenu.self, from: data)
                
                for item in fullMenu.menu {
                    let newDish = Dish(context: viewContext)
                    newDish.title = item.title
                    newDish.price = Float(item.price) ?? 0
                    newDish.image = item.image
                    newDish.dishDescription = item.description
                    newDish.category = item.category
                }

                do {
                    try viewContext.save()
                    print("Menu items saved successfully")
                } catch {
                    print("Error saving context after adding dishes: \(error)")
                }
                
                return fullMenu.menu
                
            } catch {
                throw FetchError.decodingError(error)
            }
            
        } catch {
            throw error
        }
    }
    
    private func buildPredicate() -> NSPredicate {
        return searchText == "" ?
        NSPredicate(value: true) :
        NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
}

#Preview {
    Menu()
}
