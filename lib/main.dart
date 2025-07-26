import 'package:flutter/material.dart';
import 'package:myapp/database/habit_database.dart';
import '/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/HomePage.dart';
import 'components/my_habit_tile.dart'; // Import your MyHabitTile
import 'pages/SplashScreen.dart'; // Import your SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        // Using a primary color that aligns with your habit tile gradients
        primarySwatch: Colors
            .green, // You can choose a primary color that fits your app's overall feel
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(
              0xFFD2DE32), // Matching the non-completed gradient start color
          foregroundColor: Colors.black87, // Text color for app bar
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(
              255, 19, 221, 167), // Matching the completed gradient end color
          foregroundColor: Colors.white,
        ),
        // Define text themes for consistency
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        // Card theme for calendar and other cards
        cardTheme: CardTheme(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(8.0),
        ),
      ),
      home: const SplashScreen(), 
    );
  }
}
