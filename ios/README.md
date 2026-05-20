# Native iOS app bootstrap

`OliHarryPotterBingo.xcodeproj` is the native SwiftUI iPhone app shell for the project.

Build and run steps are documented in [`../docs/ios-build-and-run.md`](../docs/ios-build-and-run.md).

## Structure

- `OliHarryPotterBingo/App/`: app entry point
- `OliHarryPotterBingo/Views/`: initial SwiftUI screens
- `OliHarryPotterBingo/Models/`: domain models for bingo content
- `OliHarryPotterBingo/Session/`: local app/session state
- `OliHarryPotterBingo/Assets/`: app asset catalogs ready for future imported card assets
- `source-assets/`: raw source artwork kept separate from compiled asset catalogs

## Integration notes

- Keep `source-assets/` as the canonical raw artwork location.
- Import processed assets into `OliHarryPotterBingo/Assets/Assets.xcassets` as app-ready resources when wiring the gameplay views.
- The app currently runs as a local-only SwiftUI shell with placeholder state and no backend dependencies.
