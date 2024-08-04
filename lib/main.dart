import 'package:flutter/material.dart';
import 'package:myapp/database/habit_database.dart';
import '/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate(); 
  } catch (e) {
  // Handle the error, e.g., print an error message or show a dialog
    print('Error initializing database: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
