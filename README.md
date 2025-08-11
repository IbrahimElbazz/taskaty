# Taskaty - Task Management App

A clean, modern Flutter task management application built with clean architecture principles, easy localization, and responsive design.

## Features

- 🌍 **Multi-language Support**: English and Arabic localization using easy_localization
- 📱 **Responsive Design**: Adaptive UI using flutter_screenutil
- 🎨 **Modern UI**: Material Design 3 with light/dark theme support
- 🏗️ **Clean Architecture**: Well-organized code structure following best practices
- ⚡ **Fast & Efficient**: Optimized performance with proper state management

## Project Structure

```
lib/
├── core/                    # Core application configuration
│   ├── app_config.dart     # App configuration, themes, and constants
│   └── constants.dart      # App-wide constants
├── features/               # Feature-based modules
│   └── home/              # Home feature
│       └── presentation/
│           └── screens/
│               └── home_screen.dart
├── shared/                 # Shared components and utilities
│   └── widgets/
│       ├── custom_button.dart
│       └── custom_text_field.dart
└── main.dart              # App entry point
```

## Dependencies

### Core Dependencies
- **flutter_screenutil**: ^5.9.0 - For responsive design
- **Custom Translation System**: Built-in localization support

### Development Dependencies
- **flutter_lints**: ^5.0.0 - For code quality and best practices

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd taskaty
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Localization

The app supports English and Arabic languages using a custom translation system. Translations are defined in:
- `lib/core/translations.dart` - All translation keys and values

### Adding New Translations

1. Add the translation key to the `_translations` map in `translations.dart`
2. Use the key in your code with the `Translations.tr()` method:
   ```dart
   Text(Translations.tr('app.title', locale: 'en'))
   ```

### Switching Languages

The app includes a language toggle button in the app bar that switches between English and Arabic. The current locale is managed at the widget level.

## Responsive Design

The app uses `flutter_screenutil` for responsive design:

- **Design Size**: 375x812 (iPhone X)
- **Adaptive Text**: Automatically scales text based on screen size
- **Responsive Spacing**: Uses `.w`, `.h`, `.sp` extensions for responsive dimensions

### Usage Examples

```dart
// Responsive dimensions
SizedBox(width: 16.w, height: 24.h)

// Responsive text
Text(
  'Hello World',
  style: TextStyle(fontSize: 16.sp),
)

// Responsive padding
Padding(padding: EdgeInsets.all(16.w))
```

## Custom Widgets

### CustomButton
A reusable button widget with loading state and icon support:
```dart
CustomButton(
  text: 'common.save',
  onPressed: () => saveData(),
  isLoading: false,
  icon: Icons.save,
)
```

### CustomTextField
A reusable text field widget with validation and localization:
```dart
CustomTextField(
  label: 'tasks.task_title',
  hint: 'tasks.task_title_hint',
  controller: titleController,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
)
```

## Theme Configuration

The app includes both light and dark themes with Material Design 3:

- **Primary Color**: Purple (#6750A4)
- **Adaptive Colors**: Automatically adjusts based on system theme
- **Consistent Styling**: Rounded corners, proper spacing, and modern design

## Architecture Principles

### Clean Architecture
- **Separation of Concerns**: UI, business logic, and data layers are separated
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has a single, well-defined purpose

### File Organization
- **Feature-based**: Code is organized by features rather than technical concerns
- **Shared Components**: Reusable widgets and utilities in the shared folder
- **Core Configuration**: App-wide settings and constants in the core folder

## Contributing

1. Follow the existing code structure and naming conventions
2. Use the provided custom widgets for consistency
3. Add translations for any new text
4. Ensure responsive design with screen utils
5. Test on different screen sizes and orientations

## Future Enhancements

- [ ] Task management features (CRUD operations)
- [ ] Local storage with SQLite or Hive
- [ ] Push notifications
- [ ] Task categories and tags
- [ ] Search and filter functionality
- [ ] Task statistics and analytics
- [ ] Cloud sync capabilities

## License

This project is licensed under the MIT License - see the LICENSE file for details.
