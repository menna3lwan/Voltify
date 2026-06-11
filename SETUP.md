# Voltify – Setup Guide

## Prerequisites
- Flutter SDK (stable channel, 3.22+)
- Dart SDK (3.2+)
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)
- Android Studio / Xcode

## Step 1: Create the Flutter project shell

Since this source code was generated without the Flutter SDK, you need to initialize the native platform folders:

```bash
# Navigate to the Voltify folder
cd Voltify

# Create a temporary Flutter project to get android/ and ios/ folders
flutter create --org com.voltify --project-name voltify temp_project

# Copy native platform folders
cp -r temp_project/android .
cp -r temp_project/ios .
cp temp_project/test/widget_test.dart test/ 2>/dev/null || true

# Clean up
rm -rf temp_project
```

## Step 2: Install dependencies

```bash
flutter pub get
```

## Step 3: Configure Firebase

### 3a. Create a Firebase project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project named **Voltify**
3. Enable **Authentication** → **Email/Password** sign-in provider

### 3b. Connect using FlutterFire CLI (recommended)

```bash
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

This automatically generates `lib/firebase_options.dart` with your real credentials.

### 3c. Manual setup (alternative)
Replace placeholder values in `lib/firebase_options.dart` with your actual Firebase config.

**Android**: Place `google-services.json` in `android/app/`
**iOS**: Place `GoogleService-Info.plist` in `ios/Runner/`

## Step 4: Add Inter font (optional)

Download Inter font from [Google Fonts](https://fonts.google.com/specimen/Inter) and place the `.ttf` files in `assets/fonts/`. If you skip this, the app will fall back to the system font via `google_fonts` package.

## Step 5: Run the app

```bash
# Android
flutter run

# iOS
cd ios && pod install && cd ..
flutter run --device-id <your-ios-device-or-simulator>
```

## Step 6: Build deliverables

```bash
# Android APK
flutter build apk --release

# iOS IPA (requires macOS + Xcode)
flutter build ipa --release
```

## Architecture

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp configuration
├── firebase_options.dart        # Firebase config (auto-generated)
├── injection_container.dart     # Dependency injection (GetIt)
├── core/
│   ├── constants/               # Colors, strings, dimensions, text styles
│   ├── theme/                   # Material theme
│   ├── utils/                   # Validators
│   └── errors/                  # Failures, Firebase error handler
└── features/
    └── auth/
        ├── data/
        │   ├── datasources/     # Firebase Auth data source
        │   └── repositories/    # Repository implementation
        ├── domain/
        │   ├── entities/        # User entity
        │   ├── repositories/    # Abstract repository
        │   └── usecases/        # Sign up use case
        └── presentation/
            ├── cubit/           # State management (Cubit + State)
            ├── screens/         # Sign Up screen
            └── widgets/         # Reusable components
```

## Testing

```bash
flutter test
```
