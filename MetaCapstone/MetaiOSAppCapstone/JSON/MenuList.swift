import Foundation

struct MenuList: Decodable, Identifiable {
    var id = UUID()
    let items: [MenuItem]
}
