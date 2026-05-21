import SwiftUI

struct CardArtworkView: View {
    let card: BingoCard?

    var body: some View {
        Group {
            if let card, let image = loadImage(for: card) {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                placeholder
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func loadImage(for card: BingoCard) -> UIImage? {
        guard let url = Bundle.main.url(forResource: card.assetName, withExtension: "png", subdirectory: "cards") else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }

    private var placeholder: some View {
        VStack(spacing: 10) {
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text(card == nil ? "No card drawn yet" : "Card artwork unavailable")
                .font(.headline)

            Text(card?.assetName ?? "Tap draw to reveal a bingo card")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 220)
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    CardArtworkView(card: BingoCard(id: "card-01"))
        .padding()
}
