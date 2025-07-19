struct MenuItem: Codable, Hashable, Identifiable {
    var id: Int
    var title: String
    var image: String
    var description: String
    var price: String
    var category: String
}
