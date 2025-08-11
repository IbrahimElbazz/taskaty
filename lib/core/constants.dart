class AppConstants {
  // App info
  static const String appName = 'Taskaty';
  static const String appVersion = '1.0.0';
  
  // API endpoints (if needed later)
  static const String baseUrl = 'https://api.taskaty.com';
  
  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String tasksKey = 'tasks';
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Task priorities
  static const List<String> priorities = ['low', 'medium', 'high'];
  
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
}
