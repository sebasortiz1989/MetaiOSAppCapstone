import SwiftUI
import CoreData

struct Menu: View {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var dishesModel = DishesModel()
    @Binding var searchText: String
    @State private var menuItems: [MenuItem] = []
    
    let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
    
    @FetchRequest<Dish>(
        sortDescriptors: [SortDescriptor(\.title)],
        animation: .default
    ) private var dishesT: FetchedResults<Dish>
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(dishesT) { dish in
                    HStack(alignment: .center, spacing: 10) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("\(dish.title ?? "")")
                                .font(.sectionTitle20)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
                            
                            Text("\(dish.dishDescription ?? "")")
                                .font(.loadTextMedium18)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black)
                                .fontWeight(.medium)
                            
                            Text("$\(String(format: "%.2f", dish.price))")
                                .font(.loadTextMedium18)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        AsyncImage(url: URL(string: dish.image ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                Spacer()
            }
        }

        .onChange(of: searchText) {
            dishesT.nsPredicate = buildPredicate()
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
