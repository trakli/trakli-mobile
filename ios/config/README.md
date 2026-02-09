# iOS Firebase config by flavor

This folder holds one `GoogleService-Info.plist` per build flavor. The Xcode build phase **"Copy Firebase config by flavor"** copies the correct file into the app bundle based on the Build Configuration (e.g. `Debug-development` → `config/development/`).

- **development** – `com.whilesmart.trakli.dev`
- **staging** – `com.whilesmart.trakli.stg` (replace plist from Firebase Console when you have a staging iOS app)
- **production** – `com.whilesmart.trakli`

To refresh a plist: run `flutterfire configure` with the right `--ios-bundle-id` and `--ios-out=ios/config/<flavor>/GoogleService-Info.plist`, or download from Firebase Console and replace the file here.
