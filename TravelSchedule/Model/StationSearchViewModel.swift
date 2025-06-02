struct City: Identifiable {
    var id: String
    var name: String
}
struct Station: Identifiable {
    var id: String
    var name: String
}
struct StationSearchViewModel {
    var shortList: [City]
    var fullList: [City]
    var stationList: (City) -> [Station]
    var onStationSelected: (City, Station) -> Void
}

extension StationSearchViewModel {
    static func mock(onStationSelected: @escaping (City, Station) -> Void) -> StationSearchViewModel {
        .init(
            shortList: [
                .init(id: "1", name: "Москва"),
                .init(id: "2", name: "Санкт Петербург"),
                .init(id: "3", name: "Сочи"),
                .init(id: "4", name: "Горный Воздух"),
                .init(id: "5", name: "Краснодар"),
                .init(id: "6", name: "Казань"),
                .init(id: "7", name: "Омск"),
            ],
            fullList: [
                .init(id: "1", name: "Москва"),
                .init(id: "2", name: "Санкт Петербург"),
                .init(id: "3", name: "Сочи"),
                .init(id: "4", name: "Горный Воздух"),
                .init(id: "5", name: "Краснодар"),
                .init(id: "6", name: "Казань"),
                .init(id: "7", name: "Омск"),
                .init(id: "8", name: "Ижевск"),
                .init(id: "9", name: "Иркутск"),
                .init(id: "10", name: "Саратов"),
            ],
            stationList: { city in
                switch city.id {
                case "1":
                    [
                        .init(id: "1", name: "Киевский вокзал"),
                        .init(id: "2", name: "Курский вокзал"),
                        .init(id: "3", name: "Ярославский вокзал"),
                        .init(id: "4", name: "Белорусский вокзал"),
                        .init(id: "5", name: "Савёловский вокзал"),
                        .init(id: "6", name: "Ленинградский вокзал"),
                    ]
                case "2":
                    [
                        .init(id: "1", name: "Московский вокзал"),
                        .init(id: "2", name: "Ладожский вокзал"),
                        .init(id: "3", name: "Финляндский вокзал"),
                        .init(id: "4", name: "Витебский вокзал"),
                        .init(id: "5", name: "Балтийский вокзал"),
                    ]
                default: []
                }
            },
            onStationSelected: onStationSelected
        )
    }
}
