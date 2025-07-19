import Foundation

struct MenuItem: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: String
    let image: String
    let category: String
}
