# Artisans Mobile

A Flutter fitness application built with Clean Architecture, featuring exercise discovery, favorites management, and robust authentication.

## Features

### Authentication
- Firebase Email/Password authentication
- Google Sign-In integration

- **Dark Mode Support**:

### Exercise Discovery
- Browse extensive exercise library from ExerciseDB API
- View detailed exercise information with animated GIFs
- Step-by-step instructions and safety tips
- **Pull-to-Refresh**: Easily refresh the exercise list to get the latest data.
- **Responsive Design**: UI scales perfectly across different screen sizes.

- **Offline Support**: Exercises are cached locally using Hive for offline access.
- Pagination support for efficient loading

###  Search & Filter
- Real-time exercise search by name
- Filter by body part (Back, Cardio, Chest, Arms, Legs, etc.)
- Dedicated search page with independent state management
- Shimmer loading effects

###  Favorites
- Save favorite exercises locally using SharedPreferences
- Quick access to saved exercises
- Persistent across app sessions

###  User Experience
- Light/Dark mode with theme persistence
- Responsive bottom navigation with Riverpod state management
- Localization support (English & Arabic)

---

##  Setup

### Prerequisites
- Flutter SDK ^3.9.2
- Firebase project (for authentication)

### Installation

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**
   ```bash
   flutterfire configure
   ```
   - Enable Email/Password authentication in Firebase Console
   - Enable Google Sign-In in Firebase Console

3. **API Configuration**
   - The project uses [ExerciseDB](https://www.exercisedb.dev) API
   - Base URL: `https://www.exercisedb.dev/api/v1`
   - No API key required (free public API)
   - Endpoints are configured in `lib/core/constants/api_constants.dart`

4. **Run the App**
   ```bash
   flutter run
   ```

---

## 🏗️ Architecture

### Clean Architecture Layers
- **Domain**: Business logic and entities
- **Data**: Repository implementations and data sources
- **Presentation**: UI components and state management

### Project Structure
```
lib/
├── core/              # Shared utilities, DI, Router, Network
├── features/
│   ├── auth/          # Authentication logic & UI
│   ├── exercises/     # Exercise listing & details
│   ├── favorites/     # Local favorites persistence
│   ├── search/        # Search functionality
│   ├── profile/       # User profile
│   └── layout/        # Main app layout
└── shared/            # Common widgets & theme
```

---

## 📦 Key Dependencies

- **State Management**: `flutter_riverpod: ^3.0.3`
- **Navigation**: `go_router: ^17.0.1`
- **Networking**: `dio: ^5.9.0`
- **Authentication**: `firebase_auth: ^6.1.3`, `google_sign_in: ^6.2.1`
- **Local Storage**: `shared_preferences: ^2.5.4`, `hive: ^2.2.3`
- **UI**: `google_fonts: ^6.3.3`, `flutter_screenutil: ^5.9.3`, `shimmer: ^3.0.0`
- **Code Generation**: `freezed: ^3.2.3`, `json_serializable: ^6.11.2`
- **Utilities**: `equatable: ^2.0.7`, `dartz: ^0.10.1`

---

## 📱 Platform Support

- ✅ **Android**: Fully supported
- ✅ **iOS**: Fully supported
- ⚠️ **Web**: Limited support

---

## 🔧 Build Commands

### Development
```bash
flutter run
```

### Release Builds

**Android APK (Universal)**
```bash
flutter build apk --release
```

**Android APK (Split by ABI - Recommended)**
```bash
flutter build apk --release --split-per-abi
```

**Android App Bundle (For Play Store)**
```bash
flutter build appbundle
```

**iOS**
```bash
flutter build ios --release
```





---

##  Localization

The app supports multiple languages:
- **English** (en)
- **Arabic** (ar) with RTL layout support



--

##  Credits

- **ExerciseDB API** for exercise data and images
- **Firebase** for authentication services
- **Flutter Community** for amazing packages

---

**Version**: 1.0.0+1  
