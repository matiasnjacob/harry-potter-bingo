# Build and run the iOS app

These steps use the native iOS project created for `FEATURE-004`.

## 1. Install and select Xcode

1. Install the full `Xcode` app.
2. Select it as the active developer directory:

   ```bash
   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
   ```

3. Open Xcode once and accept the license / install required components.

## 2. Verify Xcode command-line tools

Run:

```bash
xcodebuild -version
xcode-select -p
```

Expected result:

- `xcodebuild -version` prints the installed Xcode version
- `xcode-select -p` prints `/Applications/Xcode.app/Contents/Developer`

## 3. Confirm simulator runtime is installed

In Xcode:

- Open `Xcode > Settings > Platforms`
- Confirm an iOS simulator runtime is installed

You can also list available simulators from Terminal:

```bash
xcrun simctl list devices available
```

## 4. Open the project

Open the project from the `FEATURE-004` worktree, not from the primary workspace:

```bash
open "/Users/matiasbinagora/Projects/.worktrees/harry-potter-bingo/task-004-bootstrap-ios-app/ios/OliHarryPotterBingo.xcodeproj"
```

Or open it manually in Finder at:

`/Users/matiasbinagora/Projects/.worktrees/harry-potter-bingo/task-004-bootstrap-ios-app/ios/OliHarryPotterBingo.xcodeproj`

## 5. Select a simulator and run the app

In Xcode:

1. Choose the `OliHarryPotterBingo` scheme
2. Select an available iPhone simulator, for example `iPhone 17`
3. Press the Run button or `Cmd + R`

## 6. Build from Terminal

Option A: run from the worktree root

```bash
cd "/Users/matiasbinagora/Projects/.worktrees/harry-potter-bingo/task-004-bootstrap-ios-app"
xcodebuild -project "ios/OliHarryPotterBingo.xcodeproj" -scheme "OliHarryPotterBingo" -destination 'platform=iOS Simulator,name=iPhone 17' build
```

Option B: run from anywhere with the full project path

```bash
xcodebuild -project "/Users/matiasbinagora/Projects/.worktrees/harry-potter-bingo/task-004-bootstrap-ios-app/ios/OliHarryPotterBingo.xcodeproj" -scheme "OliHarryPotterBingo" -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## 7. Expected successful result

The simulator build should end with:

```text
** BUILD SUCCEEDED **
```

## 8. Common issue: project path does not exist

If you see:

```text
xcodebuild: error: 'ios/OliHarryPotterBingo.xcodeproj' does not exist
```

you are probably running the command from the main repo instead of the `FEATURE-004` worktree.

Use the worktree path shown above.

## 9. Real device note

Simulator build is validated.

Real iPhone deployment uses separate free-signing steps documented in [`ios-free-signing.md`](ios-free-signing.md).
