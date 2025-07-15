import Foundation

struct JSONMenu: Decodable {
    let menu: [MenuItem]
    
    enum CodingKeys: String, CodingKey {
        case menu
    }
}
