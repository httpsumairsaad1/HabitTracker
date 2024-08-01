import 'package:flutter/material.dart';
import 'dark_theme.dart';  // Ensure these files are correctly defined
import 'light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode; // Default theme

  // Getter for the current theme
  ThemeData get themeData => _themeData;

  // Check if the current theme is dark mode
  bool get isDarkMode => _themeData == darkMode;

  // Update the current theme
  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }
}
