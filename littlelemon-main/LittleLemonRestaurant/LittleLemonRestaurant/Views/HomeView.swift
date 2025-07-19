import CoreData
import SwiftUI


let fetchDataUrl =
"https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"

struct HomeView: View {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var menuItems: [MenuItem] = []
    @FocusState var isSearchFocused: Bool
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isSearchFocused = false
                    }
                
                VStack(spacing: 16) {
                    ZStack {
                        HStack {
                            Spacer()
                            Image("logo_img")
                                .imageScale(.large)
                                .scaledToFit()
                                .frame(
                                    width: 150,
                                    height: 50,
                                    alignment: .center
                                )
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: UserProfileView().navigationBarBackButtonHidden(true)) {
                                Image("profile-image-placeholder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            .padding(.trailing, 20)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HeroView()
                        
                        ZStack(alignment: .leading) {
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isSearching.toggle()
                                    }
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(._333)
                                        .frame(width: 35, height: 35)
                                        .background(Circle().fill(Color(.white)))
                                        .shadow(radius: 5)
                                }
                            }
                            .frame(height: 40)
                            
                            if isSearching {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Search", text: $searchText)
                                        .textFieldStyle(.plain)
                                        .focused($isSearchFocused)
                                }
                                .padding(.horizontal)
                                .frame(height: 40)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .offset(x: isSearching ? 0 : -40)
                                .opacity(isSearching ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3), value: isSearching)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onChange(of: isSearchFocused) { oldValue, newValue in
                            if oldValue == true && newValue == false {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    if !isSearchFocused {
                                        withAnimation {
                                            isSearching = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("primary-color"))
                    
                    DeliveryListView()
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                        .padding([.leading, .trailing], 20)
                    
                    FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) {(dishes: [Dish]) in
                        List {
                            ForEach(dishes) { dish in
                                HStack(alignment: .center, spacing: 10) {
                                    VStack(alignment: .leading, spacing: 7) {
                                        Text("\(dish.title ?? "")")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Text("\(dish.dishDescription ?? "")")
                                            .font(.headline)
                                            .foregroundStyle(.secondary)
                                        Text("$\(dish.price ?? "")")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color("primary-color"))
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
                                .listRowBackground(Color.clear)
                            }
                        }.listStyle(.plain)
                    }
                    
                }
            }
        } .onAppear(perform: {
            getMenuData()
        })
    }
    
    func getMenuData() {
        
        let urlObject = URL(string: fetchDataUrl)!
        let urlRequest = URLRequest(url: urlObject)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let menuItemsList = try JSONDecoder().decode(MenuList.self, from: data)
                    DispatchQueue.main.async {
                        
                        PersistenceController.shared.clear()
                        
                        for menuItem in menuItemsList.menu {
                            let dish = Dish(context: viewContext)
                            dish.title = menuItem.title
                            dish.price = menuItem.price
                            dish.image = menuItem.image
                            dish.dishDescription = menuItem.description
                        }
                        try? viewContext.save()
                    }
                } catch {
                    print("JSON decode error: \(error)")
                }
            } else if let error = error {
                print("Network error: \(error)")
            }
        }

        dataTask.resume()
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare))]
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS [cd] %@", searchText)
        }
    }
}

#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
