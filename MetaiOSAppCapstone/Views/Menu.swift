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
    ) private var dishesT: FetchedResults<Dish>
    
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
     
            List(dishesT) { dish in
                Text(dish.title ?? "No Title")
            }
        }
        .onAppear {
            Task {
                do {
                    menuItems = try await getMenuData()
                } catch {
                    print("Error fetching menu: \(error)")
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
        NSPredicate(format: "name CONTAINS[cd] %@", searchText)
    }
}

#Preview {
    Menu()
}
