# Home-screen widgets

The existing iOS/Android widgets (RFQ section 4.5) need native code. They live here, outside the Expo-generated
`ios/` and `android/` folders so `expo prebuild --clean` never destroys them. Wire them into the mobile app with an
Expo config plugin placed in `frontend/mobile/plugins/` when work starts.

| Folder            | Stack                                |
| ----------------- | ------------------------------------ |
| [ios](./ios)      | Swift, SwiftUI, WidgetKit (macOS + Xcode) |
| [android](./android) | Kotlin, Jetpack Glance             |
