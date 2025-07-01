struct JSONMenu: Codable {
    let menu: [MenuItem]
    
    enum CodingKeys: String, CodingKey {
        case menu = "menu"
    }
}
