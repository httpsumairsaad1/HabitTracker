import 'dart:ui'; // Import this for ImageFilter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/my_drawer.dart';
import 'package:myapp/database/habit_database.dart';
import 'package:myapp/models/habit.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();  
    super.initState();
  }

  final TextEditingController txtController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero, // Remove default padding to show gradient properly
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD2DE32),
                Color(0xFFC5E898),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassmorphicTextField(
                controller: txtController,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      String newHabitName = txtController.text;

                      context.read<HabitDatabase>().addHabit(newHabitName);
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Colors.transparent, // Set to transparent to show gradient
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD2DE32),
                Color(0xFFC5E898),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: _buildHabitList,
    );
  }
}

Widget _buildHabitList(){
  // habit db
  final habitDatabase = context.watch<HabitDatabase>();

  //current habits
  List<Habit> currentHabits = habitDatabase.currentHabits;

  // returning list 
  return ListView.builder(
    itemCount: currentHabits.length,
    itemBuilder: (context, index){
      final habit = currentHabits[index];
      bool isCompletedToday = isHabitCompletedToday();
      
    }
  );
}

class GlassmorphicTextField extends StatelessWidget {
  final TextEditingController controller;

  const GlassmorphicTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Add some transparency
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Create a new habit',
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
            ),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}



// // actions: [
// //   MaterialButton(
// //     onPressed:(){
// //       String newHabitName = textController.text;

// //       context.read<HabitDatabase>().addHabit(newHabitName);
// //       Navigator.pop(context);
// //     },
// //     child: const Text('Create') 
// //     }
// //   )
// // ]