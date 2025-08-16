# Expense Tracker

A simple cross-platform expense tracking app built with Flutter and BLoC. Easily add, filter, and manage your expenses with a clean UI and robust state management.

## Features
- Add, edit, and delete expenses
- Filter expenses by category
- Persistent storage using SharedPreferences
- Responsive UI for mobile and desktop
- Unit and BLoC tests for reliability

## Tech Stack
- **Flutter**: UI framework
- **BLoC**: State management
- **Equatable & Freezed**: Immutable models
- **SharedPreferences**: Local persistence
- **bloc_test & flutter_test**: Testing

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/andresgerstl/ecovery-test.git
   cd ecovery_test
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run code generation (for models):
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Launch the app:
   ```sh
   flutter run
   ```

### Running Tests
```sh
flutter test
```

## Project Structure
- `lib/` - Main app code
  - `model/` - Data models (Expense, ExpenseCategory)
  - `bloc/` - BLoC logic and state
  - `repository/` - Data persistence
  - `view/` - UI screens
- `test/` - Unit and BLoC tests

## Notes
- The app uses feature-first structure for scalability.
- Filtering is handled in the BLoC state.
- Models are fully immutable and use code generation for serialization.

## License
MIT
