import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var session: AppSession
    @State private var animationCard: BingoCard?
    @State private var isAnimatingDraw = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text(isAnimatingDraw ? "Shuffling the deck..." : session.statusText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    cardDisplay

                    VStack(spacing: 12) {
                        Button(primaryButtonTitle) {
                            handlePrimaryAction()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .frame(maxWidth: .infinity)
                        .disabled(isAnimatingDraw)

                        NavigationLink {
                            HistoryView()
                                .environmentObject(session)
                        } label: {
                            Label("Open History", systemImage: "list.bullet.rectangle.portrait")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAnimatingDraw)

                        Button("Reset Progress", role: .destructive) {
                            session.requestResetConfirmation()
                        }
                        .disabled(!session.hasDrawnCards || isAnimatingDraw)
                    }

                    HStack(spacing: 12) {
                        statCard(title: "Remaining", value: "\(session.remainingCardsCount)", systemImage: "sparkles.rectangle.stack")
                        statCard(title: "Drawn", value: "\(session.drawnCards.count)", systemImage: "list.number")
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Draw history", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                            .font(.headline)

                        if session.drawnCards.isEmpty {
                            Text("No cards drawn yet. Tap draw to start the session.")
                                .foregroundStyle(.secondary)
                        } else {
                            LazyVStack(spacing: 10) {
                                ForEach(Array(session.drawnCards.enumerated()), id: \.element.id) { index, card in
                                    HStack(spacing: 12) {
                                        Text("#\(index + 1)")
                                            .font(.headline.monospacedDigit())
                                            .frame(width: 42, alignment: .leading)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(card.title)
                                                .font(.subheadline.weight(.semibold))
                                            Text(card.assetName)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
            }
            .navigationTitle("Oli Harry Potter Bingo")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        HistoryView()
                            .environmentObject(session)
                    } label: {
                        Label("History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    }
                }
            }
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

    private var displayedCard: BingoCard? {
        animationCard ?? session.currentCard
    }

    private var primaryButtonTitle: String {
        if isAnimatingDraw {
            return "Drawing..."
        }

        return session.primaryActionTitle
    }

    private var cardDisplay: some View {
        VStack(spacing: 14) {
            Text(displayedCard?.title ?? "Ready to Draw")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.75)

            Text(displayedCard?.assetName ?? "Tap the button below for a slot-machine-style reveal")
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if isAnimatingDraw {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 260)
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color.blue, Color.indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.12), radius: 18, y: 10)
        .animation(.easeInOut(duration: 0.12), value: displayedCard?.id)
    }

    private func statCard(title: String, value: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))
    }

    private func handlePrimaryAction() {
        if session.isComplete {
            session.requestResetConfirmation()
            return
        }

        startDrawAnimation()
    }

    private func startDrawAnimation() {
        guard !isAnimatingDraw else {
            return
        }

        let remainingCards = session.remainingCards
        guard !remainingCards.isEmpty else {
            return
        }

        isAnimatingDraw = true

        Task {
            let loopCount = min(12, max(8, remainingCards.count))

            for index in 0..<loopCount {
                let card = remainingCards[index % remainingCards.count]
                animationCard = card

                let delay = UInt64((0.08 + (Double(index) * 0.01)) * 1_000_000_000)
                try? await Task.sleep(nanoseconds: delay)
            }

            session.drawNextCard()
            animationCard = nil
            isAnimatingDraw = false
        }
    }
}

private struct HistoryView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List {
            Section("Verification summary") {
                Label("Cards drawn: \(session.drawnCards.count)", systemImage: "checklist")
                Label("Cards remaining: \(session.remainingCardsCount)", systemImage: "square.stack.3d.up")
                Label("Session status: \(session.statusText)", systemImage: "wand.and.stars")
            }

            Section("Ordered draw history") {
                if session.drawnCards.isEmpty {
                    ContentUnavailableView(
                        "No cards drawn yet",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Draw cards from the main screen to build a verification history.")
                    )
                } else {
                    ForEach(Array(session.drawnCards.enumerated()), id: \.element.id) { index, card in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Draw #\(index + 1)")
                                    .font(.headline.monospacedDigit())
                                Spacer()
                                Text(card.assetName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Text(card.title)
                                .font(.title3.weight(.semibold))
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSession())
}
