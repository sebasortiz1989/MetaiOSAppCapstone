import Foundation

struct MenuList: Decodable, Identifiable {
    var id = UUID()
    let items: [MenuItem]
    
    enum FetchError: Error {
        case badResponse
        case invalidData
        case decodingError(Error)
    }
    
    static let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"

    static func getMenuData() async throws -> [MenuItem] {
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
                return fullMenu.menu
                
            } catch {
                throw FetchError.decodingError(error)
            }
            
        } catch {
            throw error
        }
    }
}
