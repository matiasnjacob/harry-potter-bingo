import XCTest
@testable import OliHarryPotterBingo

@MainActor
final class AppSessionTests: XCTestCase {
    func testDrawsAllTwentySixCardsExactlyOncePerSession() {
        let store = InMemorySessionStore()
        let session = AppSession(drawEngine: CardDrawEngine(makeRandomIndex: { _ in 0 }), store: store)

        for _ in 0..<26 {
            session.drawNextCard()
        }

        XCTAssertEqual(session.drawnCards.count, 26)
        XCTAssertEqual(Set(session.drawnCards.map { $0.id }).count, 26)
        XCTAssertTrue(session.isComplete)
        XCTAssertEqual(session.remainingCardsCount, 0)
    }

    func testOrderedHistoryMatchesDrawOrder() {
        let store = InMemorySessionStore()
        let session = AppSession(drawEngine: CardDrawEngine(makeRandomIndex: { _ in 0 }), store: store)

        session.drawNextCard()
        session.drawNextCard()
        session.drawNextCard()

        XCTAssertEqual(session.drawnCards.map { $0.id }, ["card-01", "card-02", "card-03"])
    }

    func testRestoreLoadsSavedHistory() {
        let store = InMemorySessionStore(snapshot: BingoSessionSnapshot(drawnCardIDs: ["card-03", "card-11"]))
        let session = AppSession(store: store)

        XCTAssertEqual(session.drawnCards.map { $0.id }, ["card-03", "card-11"])
        XCTAssertEqual(session.currentCard?.id, "card-11")
        XCTAssertEqual(session.remainingCardsCount, 24)
    }

    func testResetRequiresConfirmationAndClearsOnlyAfterConfirm() {
        let store = InMemorySessionStore()
        let session = AppSession(drawEngine: CardDrawEngine(makeRandomIndex: { _ in 0 }), store: store)
        session.drawNextCard()

        session.requestResetConfirmation()

        XCTAssertTrue(session.isResetConfirmationPresented)
        XCTAssertEqual(session.drawnCards.map { $0.id }, ["card-01"])

        session.cancelReset()
        XCTAssertFalse(session.isResetConfirmationPresented)
        XCTAssertEqual(session.drawnCards.map { $0.id }, ["card-01"])

        session.requestResetConfirmation()
        session.confirmReset()

        XCTAssertFalse(session.isResetConfirmationPresented)
        XCTAssertTrue(session.drawnCards.isEmpty)
        XCTAssertEqual(session.remainingCardsCount, 26)
        XCTAssertNil(store.snapshot)
    }

    func testCompletedSessionAllowsRestart() {
        let store = InMemorySessionStore()
        let session = AppSession(drawEngine: CardDrawEngine(makeRandomIndex: { _ in 0 }), store: store)

        for _ in 0..<26 {
            session.drawNextCard()
        }

        XCTAssertEqual(session.primaryActionTitle, "Restart Session")

        session.handlePrimaryAction()
        XCTAssertTrue(session.isResetConfirmationPresented)

        session.confirmReset()

        XCTAssertFalse(session.isComplete)
        XCTAssertTrue(session.drawnCards.isEmpty)
        XCTAssertEqual(session.remainingCardsCount, 26)
    }
}

private final class InMemorySessionStore: BingoSessionStoring {
    var snapshot: BingoSessionSnapshot?

    init(snapshot: BingoSessionSnapshot? = nil) {
        self.snapshot = snapshot
    }

    func loadSnapshot() -> BingoSessionSnapshot? {
        snapshot
    }

    func saveSnapshot(_ snapshot: BingoSessionSnapshot) {
        self.snapshot = snapshot
    }

    func clearSnapshot() {
        snapshot = nil
    }
}
