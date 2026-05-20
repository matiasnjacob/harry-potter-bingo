import Combine
import Foundation

@MainActor
final class AppSession: ObservableObject {
    @Published private(set) var snapshot: BingoSessionSnapshot
    @Published var isResetConfirmationPresented = false

    private let cardLookup: [BingoCard.ID: BingoCard]
    private let drawEngine: CardDrawEngine
    private let store: BingoSessionStoring

    init(
        cards: [BingoCard] = BingoCard.fullDeck,
        drawEngine: CardDrawEngine = CardDrawEngine(),
        store: BingoSessionStoring = UserDefaultsBingoSessionStore()
    ) {
        self.cardLookup = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })
        self.drawEngine = drawEngine
        self.store = store
        self.snapshot = store.loadSnapshot() ?? BingoSessionSnapshot()
    }

    var availableCardCount: Int {
        cardLookup.count
    }

    var statusText: String {
        if isComplete {
            return "All 26 cards drawn"
        }

        if currentCard == nil {
            return "Ready to draw"
        }

        return "In progress"
    }

    var currentCard: BingoCard? {
        snapshot.currentCardID.flatMap { cardLookup[$0] }
    }

    var drawnCards: [BingoCard] {
        snapshot.drawnCardIDs.compactMap { cardLookup[$0] }
    }

    var remainingCardsCount: Int {
        snapshot.remainingCount
    }

    var hasDrawnCards: Bool {
        !snapshot.drawnCardIDs.isEmpty
    }

    var isComplete: Bool {
        snapshot.isComplete
    }

    var primaryActionTitle: String {
        isComplete ? "Restart Session" : "Draw Next Card"
    }

    func handlePrimaryAction() {
        if isComplete {
            requestResetConfirmation()
        } else {
            drawNextCard()
        }
    }

    func drawNextCard() {
        guard !isComplete else {
            return
        }

        snapshot = drawEngine.drawNext(from: snapshot)
        persistSnapshot()
    }

    func requestResetConfirmation() {
        guard hasDrawnCards else {
            return
        }

        isResetConfirmationPresented = true
    }

    func confirmReset() {
        snapshot = BingoSessionSnapshot()
        isResetConfirmationPresented = false
        store.clearSnapshot()
    }

    func cancelReset() {
        isResetConfirmationPresented = false
    }

    private func persistSnapshot() {
        store.saveSnapshot(snapshot)
    }
}
