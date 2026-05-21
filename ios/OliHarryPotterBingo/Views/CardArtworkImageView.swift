import SwiftUI

struct CardArtworkImageView: View {
    let card: BingoCard
    var maxHeight: CGFloat

    init(card: BingoCard, maxHeight: CGFloat = 220) {
        self.card = card
        self.maxHeight = maxHeight
    }

    var body: some View {
        Group {
            if let image = loadImage(for: card) {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            } else {
                ContentUnavailableView(
                    "Artwork unavailable",
                    systemImage: "photo",
                    description: Text(card.assetName)
                )
                .frame(minHeight: min(maxHeight, 160))
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
    }

    private func loadImage(for card: BingoCard) -> UIImage? {
        guard let url = Bundle.main.url(forResource: card.assetName, withExtension: "png", subdirectory: "cards") else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }
}

#Preview {
    CardArtworkImageView(card: BingoCard(id: "card-01"), maxHeight: 180)
        .padding()
}
