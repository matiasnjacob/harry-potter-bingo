import Foundation

final class AppSession: ObservableObject {
    @Published var cards: [BingoCard]
    @Published var selectedCardID: BingoCard.ID?

    init(cards: [BingoCard] = AppSession.placeholderCards) {
        self.cards = cards
        self.selectedCardID = cards.first?.id
    }

    var availableCardCount: Int {
        cards.count
    }

    var statusText: String {
        selectedCardID == nil ? "No card selected" : "Placeholder card selected"
    }
}

private extension AppSession {
    static let placeholderCards: [BingoCard] = [
        BingoCard(id: 1, title: "Placeholder Card", assetName: "card-placeholder")
    ]
}
