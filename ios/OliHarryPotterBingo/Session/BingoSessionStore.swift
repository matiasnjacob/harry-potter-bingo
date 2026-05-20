import Foundation

protocol BingoSessionStoring {
    func loadSnapshot() -> BingoSessionSnapshot?
    func saveSnapshot(_ snapshot: BingoSessionSnapshot)
    func clearSnapshot()
}

struct UserDefaultsBingoSessionStore: BingoSessionStoring {
    private let userDefaults: UserDefaults
    private let sessionKey: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard, sessionKey: String = "bingo-session-snapshot") {
        self.userDefaults = userDefaults
        self.sessionKey = sessionKey
    }

    func loadSnapshot() -> BingoSessionSnapshot? {
        guard let data = userDefaults.data(forKey: sessionKey) else {
            return nil
        }

        return try? decoder.decode(BingoSessionSnapshot.self, from: data)
    }

    func saveSnapshot(_ snapshot: BingoSessionSnapshot) {
        guard let data = try? encoder.encode(snapshot) else {
            return
        }

        userDefaults.set(data, forKey: sessionKey)
    }

    func clearSnapshot() {
        userDefaults.removeObject(forKey: sessionKey)
    }
}
