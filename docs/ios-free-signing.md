# Free Apple signing for direct iPhone install

This guide covers the zero-cost path for installing the app from Xcode onto a personal iPhone.

## Current project defaults

- Signing style: `Automatic`
- Bundle identifier: `com.matiasbinagora.oliharrypotterbingo`
- Target: `OliHarryPotterBingo`

## 1. Add your Apple ID in Xcode

In Xcode:

1. Open `Xcode > Settings > Accounts`
2. Add the Apple ID you want to use for free signing
3. Confirm your personal team appears in Xcode

## 2. Open the project

Use the project in this worktree:

```bash
open "/Users/matiasbinagora/Projects/.worktrees/harry-potter-bingo/task-009-free-apple-signing-direct-iphone-install/ios/OliHarryPotterBingo.xcodeproj"
```

## 3. Configure signing in Xcode

1. Select the `OliHarryPotterBingo` project
2. Select the `OliHarryPotterBingo` target
3. Open the `Signing & Capabilities` tab
4. Keep `Automatically manage signing` enabled
5. In `Team`, choose your personal Apple ID team
6. Confirm the bundle identifier is unique

Recommended bundle identifier in this repo:

```text
com.matiasbinagora.oliharrypotterbingo
```

If Xcode reports that the identifier is already taken, change it to another unique reverse-DNS value you control.

## 4. Connect and prepare the iPhone

1. Connect the iPhone by cable
2. Unlock the iPhone
3. Trust the Mac if prompted
4. On the iPhone, enable:
   - `Settings > Privacy & Security > Developer Mode`
5. Restart the iPhone if Apple requires it after enabling Developer Mode

## 5. Select the iPhone as the run destination

In Xcode's toolbar:

1. Select the `OliHarryPotterBingo` scheme
2. Choose your personal iPhone as the run destination

## 6. Build and install from Xcode

1. Press `Cmd + R`
2. Allow Xcode to create the free provisioning profile if prompted
3. Wait for the app to sign, install, and launch on the iPhone

## 7. If the phone blocks app launch

On the iPhone, go to:

- `Settings > General > VPN & Device Management`

Then trust the developer profile tied to your Apple ID if required.

## 8. Known limitations of free provisioning

- Free provisioning is tied to a personal Apple ID team
- Signing settings may remain user-specific and should be verified locally in Xcode
- Provisioning can expire and may require reinstalling from Xcode later
- Advanced capabilities may be unavailable on the free tier
- Device deployment requires Developer Mode on the iPhone

## 9. Validation target for this feature

Successful outcome:

- Xcode signs the app with the selected personal team
- The app installs onto the personal iPhone
- The app launches from the device after trust/developer-mode steps are complete
