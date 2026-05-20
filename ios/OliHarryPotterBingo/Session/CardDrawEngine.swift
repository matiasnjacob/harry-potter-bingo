import Foundation

struct CardDrawEngine {
    var makeRandomIndex: (Int) -> Int

    init(makeRandomIndex: @escaping (Int) -> Int = { upperBound in
        Int.random(in: 0..<upperBound)
    }) {
        self.makeRandomIndex = makeRandomIndex
    }

    func drawNext(from snapshot: BingoSessionSnapshot) -> BingoSessionSnapshot {
        guard !snapshot.isComplete else {
            return snapshot
        }

        let remainingCardIDs = snapshot.remainingCardIDs
        let nextCardID = remainingCardIDs[makeRandomIndex(remainingCardIDs.count)]

        var updatedSnapshot = snapshot
        updatedSnapshot.drawnCardIDs.append(nextCardID)
        return updatedSnapshot
    }
}
