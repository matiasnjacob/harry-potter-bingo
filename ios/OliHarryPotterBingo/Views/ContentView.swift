import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        NavigationStack {
            List {
                Section("Current draw") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(session.currentCard?.title ?? "No card drawn yet")
                            .font(.title2.weight(.semibold))

                        Text(session.currentCard?.assetName ?? "Tap draw to begin the session.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Session status") {
                    Label("Cards available: \(session.availableCardCount)", systemImage: "square.grid.3x3")
                    Label("Cards remaining: \(session.remainingCardsCount)", systemImage: "number")
                    Label("Session status: \(session.statusText)", systemImage: "wand.and.stars")
                    Label("History count: \(session.drawnCards.count)", systemImage: "list.number")
                }

                Section("Actions") {
                    Button(session.primaryActionTitle) {
                        session.handlePrimaryAction()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset Progress", role: .destructive) {
                        session.requestResetConfirmation()
                    }
                    .disabled(!session.hasDrawnCards)
                }

                Section("Draw history") {
                    if session.drawnCards.isEmpty {
                        Text("No cards drawn yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(Array(session.drawnCards.enumerated()), id: \.element.id) { index, card in
                            HStack {
                                Text("#\(index + 1)")
                                    .font(.headline.monospacedDigit())
                                VStack(alignment: .leading) {
                                    Text(card.title)
                                    Text(card.assetName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("MVP Shell")
            .alert("Reset session?", isPresented: $session.isResetConfirmationPresented) {
                Button("Cancel", role: .cancel) {
                    session.cancelReset()
                }
                Button("Reset", role: .destructive) {
                    session.confirmReset()
                }
            } message: {
                Text("This will clear the current draw history and start a new 26-card session.")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSession())
}
