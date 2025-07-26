import 'package:flutter/material.dart';
import '../pages/HomePage.dart'; // Import HomePage
import '../pages/streakPage.dart'; // Import StreakPage
import '../pages/AnalysisPage.dart'; // Import the AnalysisPage

class MyDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> habits; // Add this line to receive habits

  const MyDrawer({Key? key, required this.habits})
      : super(key: key); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100], // Light background for the drawer
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(
                      0xFFD2DE32), // Matching your non-completed gradient start
                  const Color.fromARGB(255, 135, 183,
                      14), // Matching your non-completed gradient end
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                'HabiTask', // Changed to HabiTask for consistency
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Home Page Option
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Page', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              if (ModalRoute.of(context)?.settings.name != '/') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          // Streak Option
          ListTile(
            leading: const Icon(Icons.local_fire_department),
            title: const Text('Streak', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StreakPage()),
              );
            },
          ),
          // Analysis Option
          ListTile(
            leading: const Icon(Icons.analytics), // Analytics icon
            title: const Text('Analysis', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalysisPage(
                    habits: habits, // Pass the habits received by MyDrawer
                  ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Analysis page loaded!")),
              );
            },
          ),
          // About Us Option
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("About Us page coming soon!")),
              );
            },
          ),
          const Spacer(), // Pushes content to the top
          // Optional: Add a version number or app name at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
