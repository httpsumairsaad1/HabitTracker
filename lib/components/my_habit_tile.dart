import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [const Color(0xFFC5E898), const Color(0xFFA5D641)] // Gradient if completed
              : [const Color(0xFFD2DE32), Color.fromARGB(255, 135, 183, 14)], // Gradient if not completed
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(36),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: ListTile(
        title: Text(text),
        leading: Checkbox(
          value: isCompleted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
