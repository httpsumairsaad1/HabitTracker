import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
  final String habitName;
  final bool isCompleted;
  final VoidCallback
      onTap; // Callback for when the tile is tapped (to toggle completion)
  final VoidCallback onEdit; // Callback for editing the habit
  final VoidCallback onDelete; // Callback for deleting the habit

  const MyHabitTile({
    Key? key,
    required this.habitName,
    required this.isCompleted,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap, // Toggle completion on tap
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // Conditional gradient colors based on completion status
            gradient: LinearGradient(
              colors: isCompleted
                  ? [
                      const Color.fromARGB(255, 157, 245, 62),
                      const Color.fromARGB(255, 19, 221, 167)
                    ] // Gradient if completed
                  : [
                      const Color(0xFFD2DE32),
                      const Color.fromARGB(255, 135, 183, 14)
                    ], // Gradient if not completed
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Habit Name and Completion Icon
              Expanded(
                child: Row(
                  children: [
                    // Checkmark or circle icon
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: isCompleted ? Colors.white : Colors.black54,
                      size: 28,
                    ),
                    const SizedBox(width: 15),
                    // Habit Name
                    Flexible(
                      child: Text(
                        habitName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? Colors.white : Colors.black87,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.white70,
                          decorationThickness: 2,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Handle long habit names
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons (Edit and Delete)
              Row(
                children: [
                  // Edit Button
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: isCompleted ? Colors.white70 : Colors.black54),
                    onPressed: onEdit,
                    tooltip: 'Edit Habit',
                  ),
                  // Delete Button
                  IconButton(
                    icon: Icon(Icons.delete,
                        color: isCompleted ? Colors.white70 : Colors.black54),
                    onPressed: onDelete,
                    tooltip: 'Delete Habit',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
