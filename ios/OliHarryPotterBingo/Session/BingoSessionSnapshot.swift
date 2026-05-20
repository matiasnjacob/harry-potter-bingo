import Foundation

struct BingoSessionSnapshot: Codable, Equatable {
    var drawnCardIDs: [BingoCard.ID]

    init(drawnCardIDs: [BingoCard.ID] = []) {
        self.drawnCardIDs = drawnCardIDs
    }

    var currentCardID: BingoCard.ID? {
        drawnCardIDs.last
    }

    var drawnCount: Int {
        drawnCardIDs.count
    }

    var remainingCardIDs: [BingoCard.ID] {
        let drawnSet = Set(drawnCardIDs)
        return BingoCard.fullDeckIDs.filter { !drawnSet.contains($0) }
    }

    var remainingCount: Int {
        remainingCardIDs.count
    }

    var isComplete: Bool {
        drawnCount == BingoCard.fullDeck.count
    }
}
