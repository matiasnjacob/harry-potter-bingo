import Foundation

struct BingoCard: Identifiable, Hashable, Codable {
    let id: String

    var title: String {
        id.replacingOccurrences(of: "-", with: " ").capitalized
    }

    var assetName: String {
        id
    }
}

extension BingoCard {
    static let fullDeck: [BingoCard] = (1...26).map { index in
        BingoCard(id: String(format: "card-%02d", index))
    }

    static let fullDeckIDs = fullDeck.map(\.id)
}
