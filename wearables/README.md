# Wearables

Native companion apps. These are **not** React Native: watchOS and Wear OS have no React Native runtime, so each is a
standalone native project that talks to the same Django REST API (and, for phone sync, to the mobile app).

| Folder                  | Platform | Language / UI                 | IDE (OS)                         |
| ----------------------- | -------- | ----------------------------- | -------------------------------- |
| [watchos](./watchos)    | Apple Watch | Swift, SwiftUI, WidgetKit complications | Xcode (**macOS only**) |
| [wearos](./wearos)      | Wear OS  | Kotlin, Jetpack Compose for Wear OS, Tiles & Complications | Android Studio (Windows/WSL-host, macOS, Linux) |

Scope from the RFQ (section 4.6): prayer-time display, countdown to next prayer, Qibla direction, Hijri date,
complications/tiles, haptic alerts at prayer times, offline caching, and sync of planner reminders.
