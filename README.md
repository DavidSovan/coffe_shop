# UC Coffee Shop

A Flutter app for a coffee shop experience with authentication, product catalog, cart, orders and checkout.

The UI follows a consistent CoffeeShop theme (primary brown and accent orange) across login/register, product, cart, and checkout screens.

## Tech Stack

- Flutter (Dart >= 3.8)
- State management: `provider`
- HTTP Client: `dio`
- Local storage: `shared_preferences`
- Environment variables: `flutter_dotenv`

## Prerequisites

- Flutter SDK (latest stable recommended, Dart >= 3.8.x)
  - Verify with: `flutter --version`
- For mobile:
  - Android Studio + Android SDK, emulator or device with USB debugging
  - Xcode (for iOS/macOS), CocoaPods installed: `sudo gem install cocoapods`
- For desktop (optional):
  - Enable desktop: `flutter config --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop`

## 1) Clone the repository

```bash
git clone https://github.com/your-org/uc_coffee_shop.git
cd uc_coffee_shop
```

## 2) Configure environment variables

This project uses `flutter_dotenv` and expects a `.env` file at the project root. The `BASE_URL` is required by `lib/core/network/dio.dart`:

```dart
BaseOptions(
  baseUrl: dotenv.env['BASE_URL']!,
)
```

Create `.env` in the project root:

```bash
cp .env.example .env  # if provided
# or create manually
```

`.env` example:

```
# API base URL used for all network requests
BASE_URL=https://api.example.com
```

Important:
- Do not commit secrets. `.env` is listed in `pubspec.yaml` assets so it can be bundled at build time, but keep it out of version control.
- The `BASE_URL` must be set; otherwise the app will crash at startup due to a null check on `dotenv.env['BASE_URL']`.

## 3) Install dependencies

```bash
flutter pub get
```

If building for iOS/macOS for the first time:

```bash
cd ios && pod install && cd -
```

## 4) Run the app

List available devices:

```bash
flutter devices
```

Run on a specific device (examples):

```bash
# Android emulator or device
flutter run -d android

# iOS simulator
flutter run -d ios

# Web (Chrome)
flutter run -d chrome

# Linux / macOS / Windows (if enabled)
flutter run -d linux
flutter run -d macos
flutter run -d windows
```

## Common workflows

- Analyze code:
  ```bash
  flutter analyze
  ```

- Format code:
  ```bash
  dart format .
  ```

- Run tests:
  ```bash
  flutter test
  ```

## Build commands

- Android APK (release):
  ```bash
  flutter build apk --release
  ```

- Android App Bundle (Play Store):
  ```bash
  flutter build appbundle --release
  ```

- iOS (archive from Xcode after generating):
  ```bash
  flutter build ios --release
  ```

- Web:
  ```bash
  flutter build web --release
  ```

- Desktop (example Linux):
  ```bash
  flutter build linux --release
  ```

## Project structure (high level)

- `lib/`
  - `core/network/` – `DioClient` setup
  - `features/` – modular features: `auth/`, `product/`, `orders/`, `payments/`
  - `theme/` – app theme
  - `main.dart` – app entry point

## Troubleshooting

- App crashes on startup with a null-check error around `baseUrl`:
  - Ensure `.env` exists and `BASE_URL` is set to a valid URL.

- iOS build errors related to CocoaPods:
  - Run `cd ios && pod repo update && pod install && cd -`
  - Ensure Xcode command line tools are selected: `xcode-select --install`

- No devices found:
  - Start an emulator or connect a device, then re-run `flutter devices`.

## Contributing

1. Create a feature branch from `main`.
2. Make changes with clear commit messages.
3. Run `flutter analyze`, `dart format .`, and `flutter test`.
4. Open a pull request with a clear description and screenshots when applicable.

---

For more Flutter guidance, see the official [Flutter documentation](https://docs.flutter.dev/).
