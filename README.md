# 📍 Real-Time Location Tracker (Module 25 Assignment)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Provider](https://img.shields.io/badge/State%20Management-Provider-blue)](https://pub.dev/packages/provider)
[![Google Maps](https://img.shields.io/badge/Maps-Google%20Maps%20Flutter-4285F4?logo=google-maps&logoColor=white)](https://pub.dev/packages/google_maps_flutter)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)]()

A comprehensive, production-grade Flutter application built for **Module 25 Assignment: Google Maps and Geolocator**. The application tracks user movement in real-time, displays an animated camera viewport that smoothly follows the device location, plots a continuous polyline route of the user's travel history, and features an interactive marker with coordinate tooltips.

---

## 📑 Table of Contents

- [About The App](#-about-the-app)
- [UI Showcase](#-ui-showcase)
- [Core Features Deep Dive](#-core-features-deep-dive)
  - [1. Automatic Map Animation](#1-automatic-map-animation)
  - [2. Real-Time Location Updates (Every 10s)](#2-real-time-location-updates-every-10s)
  - [3. Dynamic Polyline Route Tracking](#3-dynamic-polyline-route-tracking)
  - [4. Interactive Marker & Persistent InfoWindow](#4-interactive-marker--persistent-infowindow)
  - [5. Resilient Permission & Error Handling](#5-resilient-permission--error-handling)
  - [6. Camera Recenter Control](#6-camera-recenter-control)
- [Folder & File Architecture](#-folder--file-architecture)
- [Packages & Dependencies](#-packages--dependencies)
- [Platform Configuration (Android)](#-platform-configuration-android)
- [Getting Started & Installation](#-getting-started--installation)
- [Testing & Quality Verification](#-testing--quality-verification)
- [💡 Future Enhancements & Ideas](#-future-enhancements--ideas)
- [Author & Acknowledgments](#-author--acknowledgments)

---

## 📖 About The App

In modern mobile software, real-time geolocation is fundamental to applications like ride-sharing (Uber, Pathao), food delivery (Foodpanda), courier logistics, and fitness tracking. 

This project demonstrates how to implement a battery-efficient, reliable, and smooth real-time tracking architecture using Flutter, Google Maps Android/Web SDK, and device GPS sensors.

### Highlights:
- **Clean Architecture:** Strict separation between Presentation (UI/Widgets), Business Logic (ChangeNotifier Provider), and Core Services (Geolocator abstraction).
- **Smooth Animation:** Panning camera movements that eliminate jarring view jumps.
- **Battery-Friendly Polling:** High-accuracy GPS samples taken at a consistent 10-second interval.
- **Zero Flickering:** State-preserving markers and polyline updates that do not rebuild or reload the native map view.

---

## 📱 UI Showcase

<p align="center">
  <img src="ui_screenshot/Home%20Screen.jpeg" width="340" alt="Real-Time Location Tracker Live Screenshot" style="border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);" />
  <br>
  <em>Figure 1: Live app running on physical device (Vivo - Android 13) showing active GPS fix, custom marker, polyline trajectory, and recenter button.</em>
</p>

---

## 🚀 Core Features Deep Dive

### 1. Automatic Map Animation
- **Requirement:** Display a Google Map view that smoothly animates to the user's current location.
- **Implementation:** 
  - Once the initial GPS fix is obtained, `LocationTrackerProvider` triggers `animateToCurrentLocation()`.
  - Uses `GoogleMapController.animateCamera()` targeting `CameraPosition(target: LatLng, zoom: 16.0)` with smooth hardware-accelerated viewport panning.
  - Automatically adjusts the viewport when position changes, keeping the user centered.

### 2. Real-Time Location Updates (Every 10s)
- **Requirement:** Fetch the user's current location every 10 seconds and update the marker's position on the map.
- **Implementation:**
  - An internal `Timer.periodic(const Duration(seconds: 10))` runs continuously in the provider.
  - Calls `LocationService.getCurrentPosition()` requesting high accuracy (`LocationAccuracy.high`).
  - Updates the marker's latitude/longitude on the map seamlessly without interrupting user gestures.

### 3. Dynamic Polyline Route Tracking
- **Requirement:** Draw a polyline on the map connecting previous and current locations, continuously updating as location changes.
- **Implementation:**
  - Maintains an ordered list of `LatLng` coordinates (`_polylineCoordinates`).
  - Appends each verified location reading to this coordinate list.
  - Dynamically renders a `Polyline` with id `tracking_route_polyline`, vibrant blue color (`Colors.blue`), and a width of `6` pixels for crisp road alignment.

### 4. Interactive Marker & Persistent InfoWindow
- **Requirement:** Allow users to tap the marker to open an info window showing "My current location" as title and user's latitude and longitude as snippet.
- **Implementation:**
  - Configured with `Marker.infoWindow: InfoWindow(title: 'My Current Location', snippet: '${lat}, ${lng}')`.
  - Tapping the marker opens the native tooltip.
  - **State Preservation:** When a new 10-second location update arrives, if the user had the InfoWindow open, the provider automatically preserves its visibility using `_mapController.showMarkerInfoWindow()`, preventing abrupt tooltip closure.
  - Tapping anywhere else on the map cleanly dismisses the InfoWindow.

### 5. Resilient Permission & Error Handling
- **Requirement:** Gracefully handle location services turned off or denied permissions.
- **Implementation:**
  - `LocationService` checks `isLocationServiceEnabled()` and queries `checkPermission()` / `requestPermission()`.
  - If GPS is disabled or permission denied, the screen presents a clean top banner (`LocationErrorBanner`) explaining the issue with an instant **Retry** action button.
  - Initial load presents a card overlay with `CircularProgressIndicator` and status text.

### 6. Camera Recenter Control
- **Implementation:**
  - A prominent Floating Action Button with `Icons.my_location` in the bottom-right.
  - Allows the user to freely explore other regions of the map and quickly snap back to their live position with one tap.

---

## 📂 Folder & File Architecture

The codebase adheres strictly to clean code guidelines, separating responsibilities into modular directories:

```
module_25_assignment/
├── android/                             # Native Android project configuration
│   └── app/src/main/
│       └── AndroidManifest.xml          # Location permissions, queries & Google Maps API key
├── ui_screenshot/                       # Application screenshots for documentation
│   └── Home Screen.jpeg                 # Real device screenshot
├── lib/
│   ├── main.dart                        # Application root entry point
│   ├── app.dart                         # MultiProvider setup & MaterialApp configuration
│   ├── routes.dart                      # App routing definitions
│   │
│   ├── core/                            # Shared core utilities & services
│   │   ├── constants/
│   │   │   └── app_constants.dart       # App-wide constants (intervals, zoom, styles, keys)
│   │   └── services/
│   │       └── location_service.dart    # Wrapper for Geolocator API & permission workflows
│   │
│   └── features/                        # Feature modules
│       ├── location_tracker/            # Main real-time tracker feature
│       │   ├── presentation/
│       │   │   ├── screens/
│       │   │   │   └── location_tracker_screen.dart # Modular tracker screen
│       │   │   └── widgets/
│       │   │       ├── map_view_widget.dart         # Reusable GoogleMap component
│       │   │       └── location_error_banner.dart   # In-app error & retry banner
│       │   └── providers/
│       │       └── location_tracker_provider.dart   # State manager (timer, markers, polylines)
│       └── presentations/
│           └── home_screen.dart         # Main screen with AppBar, MapView & Recenter FAB
│
├── test/
│   └── widget_test.dart                 # Automated unit and widget tests
├── pubspec.yaml                         # Dependency management file
└── README.md                            # Complete project documentation
```

### Detailed File Responsibilities:
- **`app_constants.dart`**: Central repository for all static values (10-second timer interval, 16.0 camera zoom level, fallback coordinates, polyline width and color).
- **`location_service.dart`**: Encapsulates all interactions with the `geolocator` plugin, isolating third-party API changes from the UI.
- **`location_tracker_provider.dart`**: Business logic hub that manages the timer lifecycle, updates position history, builds polylines/markers, and controls camera animation.
- **`map_view_widget.dart`**: Clean declarative widget that consumes provider state and renders the `GoogleMap`.
- **`home_screen.dart`**: The primary user-facing scaffold containing the customized AppBar, Map layer, loading overlay, and FloatingActionButton.

---

## 📦 Packages & Dependencies

| Package | Version | Purpose in Application |
|---|---|---|
| **[google_maps_flutter](https://pub.dev/packages/google_maps_flutter)** | `^2.18.1` | Native Google Maps rendering, camera animators, markers, polylines, and info windows. |
| **[geolocator](https://pub.dev/packages/geolocator)** | `^14.1.0` | Hardware GPS polling, location service status check, and runtime permission dialogs. |
| **[provider](https://pub.dev/packages/provider)** | `^6.1.5+1` | Reactive state management connecting GPS polling with UI layers. |
| **[cupertino_icons](https://pub.dev/packages/cupertino_icons)** | `^1.0.8` | Asset set for standard icons. |
| **[flutter_lints](https://pub.dev/packages/flutter_lints)** | `^6.0.0` | Official Flutter static analysis and linting guidelines. |

---

## ⚙️ Platform Configuration (Android)

Configured in [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml):

### 1. Location & Network Permissions
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### 2. Google Maps API Key
```xml
<application ...>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="AIzaSyCY8JlZ5ULZwGOsYdPP-l9VMoPl35K6P2I" />
```

### 3. Android 11+ (API 30+) Package Queries
Required to enable communication between the application and Google Play Services on modern Android OS:
```xml
<queries>
    <package android:name="com.google.android.gms" />
    <package android:name="com.google.android.apps.maps" />
    <intent>
        <action android:name="android.intent.action.PROCESS_TEXT" />
        <data android:mimeType="text/plain" />
    </intent>
</queries>
```

---

## 🛠️ Getting Started & Installation

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`v3.12.0` or later)
- Android Studio or VS Code with Flutter & Dart extensions
- Android device or emulator with Google Play Services enabled

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/biswasbn99/module_25_assignment.git
   cd module_25_assignment
   ```

2. **Fetch all dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify analyzer & tests:**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the application:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Quality Verification

- **Code Quality:** Verified with `flutter analyze` — **0 warnings, 0 errors, 0 lints**.
- **Automated Tests:** Verified with `flutter test` — **All widget tests passing**.
- **Physical Device Execution:** Validated on **Vivo  (Android 13 / API 33)** with real-time GPS signal, accurate polyline creation, and smooth camera animation.

---

## 💡 Future Enhancements & Ideas

Here are recommended future features to take this application to the next level:

1. **🚗 Custom Marker Icons:**
   - Replace the default pin with custom rotating vehicle icons (e.g. delivery bike, car) that rotate according to the user's heading (`Position.heading`).
2. **📊 Speed & Distance Odometer Dashboard:**
   - Add a bottom sheet showing total distance traveled (km), elapsed time, and current speed (`Position.speed`).
3. **🌙 Dynamic Dark / Night Mode Map Styling:**
   - Load custom JSON map styles to automatically switch to night/retro mode when system dark mode is active.
4. **🔄 Foreground Service Tracking:**
   - Integrate `flutter_background_service` to allow continuous location tracking and polyline recording even when the app is minimized or the screen is locked.
5. **📥 Offline Route History & Export:**
   - Save tracked coordinate routes locally via SQLite/Hive and export them as GPX or KML files.

---

## 👨‍💻 Author & Acknowledgments

- **Developer:** BN Biswas


