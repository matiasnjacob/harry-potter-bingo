import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Oli Harry Potter Bingo")
                    .font(.largeTitle.bold())

                Text("SwiftUI shell ready for native gameplay, card assets, and local session state.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 12) {
                    Label("Cards available for import: \(session.availableCardCount)", systemImage: "square.grid.3x3")
                    Label("Session status: \(session.statusText)", systemImage: "wand.and.stars")
                    Label("Asset source folder: ios/source-assets", systemImage: "photo.stack")
                }
                .font(.headline)

                Spacer()

                Text("Placeholder content")
                    .font(.title3.weight(.semibold))
                Text("Next steps: import normalized cards into the asset catalog, wire up session flow, and replace this shell with bingo board navigation.")
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .navigationTitle("MVP Shell")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSession())
}
