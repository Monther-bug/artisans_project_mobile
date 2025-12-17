# Artisans Mobile Demo

A Flutter application built with Clean Architecture, demonstrating robust structure, simple authentication, exercise listing with searching/filtering, and local favorites persistence.

## Features

- **Authentication**: Firebase Auth (Login, Register, Google Sign-In*).
- **Exercises**: List exercises from ExerciseDB API, Search by name, Filter by body part.
- **Details**: View exercise GIF and instructions.
- **Favorites**: Save exercises locally (SharedPreferences).
- **Theming**: Light/Dark mode toggle with persistence.
- **Architecture**: Clean Architecture (Domain, Data, Presentation) + Riverpod + GoRouter + Frozen/JsonSerializable.

## Setup

1.  **Dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Firebase**:
    - Project requires Firebase setup.
    - Run `flutterfire configure` to generate `firebase_options.dart`.
    - Ensure Authentication (Email/Password & Google) is enabled in Firebase Console.

3.  **API Key**:
    - The project uses [ExerciseDB](https://rapidapi.com/justin-wf/api/exercisedb) via RapidAPI.
    - Open `lib/core/constants/api_constants.dart` and add your RapidAPI Key if needed (or ensure headers are correct).

4.  **Run**:
    ```bash
    flutter run
    ```

## Architecture

- **Core**: Shared utilities, DI, Router, Network Client.
- **Features**:
  - `auth`: Authentication logic & UI.
  - `exercises`: Remote data fetching & Listing UI.
  - `favorites`: Local persistence & UI.
- **Shared**: Common widgets & Theme.

## Dependencies

- `flutter_riverpod`: State Management.
- `go_router`: Navigation.
- `dio`: Networking.
- `get_it` / `injectable`: Dependency Injection.
- `firebase_auth` / `google_sign_in`: Authentication.
- `shared_preferences`: Local Storage.
- `freezed`: Data Class generation.

## Workarounds

- Downgraded `google_sign_in` to `^6.2.1` due to breaking changes in 7.x compatible with current implementations.
