struct City: Identifiable, Equatable, Hashable, Codable {
    var id: String
    var name: String
    var stations: [Station]
}
