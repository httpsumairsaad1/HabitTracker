import 'package:flutter/material.dart';
import '/themes/theme_provider.dart';
import 'package:provider/provider.dart';
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2462751260.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3759448664.
import 'pages/homePage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
