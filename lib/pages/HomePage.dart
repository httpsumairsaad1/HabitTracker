import 'package:flutter/material.dart';
import '../components/my_habit_tile.dart'; // Adjust path as needed
import '../components/my_drawer.dart'; // Import your MyDrawer
import 'AnalysisPage.dart'; // Import AnalysisPage to pass data

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Habit data structure: now only includes name and completion status
  List<Map<String, dynamic>> allHabits = [
    {"name": "Drink 8 glasses of water", "isCompleted": false},
    {"name": "Read for 30 minutes", "isCompleted": true},
    {"name": "Exercise for 1 hour", "isCompleted": false},
    {"name": "Meditate for 10 minutes", "isCompleted": false},
    {"name": "Learn a new language for 15 minutes", "isCompleted": false},
    {"name": "Call a family member", "isCompleted": true},
    {"name": "Write daily journal", "isCompleted": false},
    {"name": "Plan next day", "isCompleted": true},
  ];

  int get totalTasks => allHabits.length;
  int get completedTasks => allHabits.where((habit) => habit['isCompleted'] == true).length;
  int get pendingTasks => totalTasks - completedTasks;

  /// Toggles the completion status of a habit.
  void toggleHabitCompletion(int index) {
    setState(() {
      allHabits[index]["isCompleted"] = !allHabits[index]["isCompleted"];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Habit completion toggled!")),
    );
  }

  /// Shows a dialog to add a new habit.
  void addNewHabit() {
    TextEditingController habitNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Habit'),
          content: TextField(
            controller: habitNameController,
            decoration: const InputDecoration(hintText: "Enter habit name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (habitNameController.text.isNotEmpty) {
                  setState(() {
                    allHabits.add({
                      "name": habitNameController.text,
                      "isCompleted": false,
                    });
                  });
                  Navigator.pop(context); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Habit '${habitNameController.text}' added!")),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Placeholder for editing a habit.
  /// In a real app, this would show a dialog similar to add habit.
  void editHabit(int index) {
    final habitToEdit = allHabits[index];
    TextEditingController editController = TextEditingController(text: habitToEdit["name"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Habit'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: "Edit habit name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  setState(() {
                    allHabits[index]["name"] = editController.text;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Habit updated to '${editController.text}'!")),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /// Deletes a habit from the list.
  void deleteHabit(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: const Text('Are you sure you want to delete this habit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  allHabits.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Habit deleted!")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        centerTitle: true,
        elevation: 4,
      ),
      drawer: MyDrawer(habits: allHabits), // Pass allHabits to MyDrawer
      body: Column(
        children: [
          // Task Counts Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCountCard('Total', totalTasks, Colors.blueAccent),
                _buildCountCard('Completed', completedTasks, const Color.fromARGB(255, 157, 245, 62)),
                _buildCountCard('Pending', pendingTasks, const Color(0xFFD2DE32)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1), // Separator
          Expanded(
            child: allHabits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_box_outline_blank, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 10),
                        const Text(
                          'No habits yet!',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Tap the "+" button to add a new one.',
                          style: TextStyle(fontSize: 14, color: Colors.black45),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: allHabits.length,
                    itemBuilder: (context, index) {
                      final habit = allHabits[index];
                      return MyHabitTile(
                        habitName: habit["name"],
                        isCompleted: habit["isCompleted"],
                        onTap: () => toggleHabitCompletion(index),
                        onEdit: () => editHabit(index),
                        onDelete: () => deleteHabit(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewHabit,
        tooltip: 'Add New Habit',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCountCard(String title, int count, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
