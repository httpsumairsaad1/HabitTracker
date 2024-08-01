import 'package:isar/isar.dart';
import 'package:myapp/models/app_settings.dart';
import 'package:myapp/models/habit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

class HabitDatabase extends ChangeNotifier{
  static late Isar isar;

  static Future<void> initialize() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [AppSettingsSchema, HabitSchema],
    directory: dir.path,
    // inspector: true,
  );
}

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if(existingSettings == null){
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }


  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  final List<Habit> currentHabits = [];
  //CRUD Operations

  //Create
  Future<void> addHabit(String habitName) async {
    //create new habit
    final newHabit = Habit()..name = habitName;
    //save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));
    //re-read from db
    readHabits();
  }

  //Read
  Future<void> readHabits() async {
    // fetch all habits from the database
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    
    //update UI
    notifyListeners();
  }

  //Update
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //get habit from db 
    final habit = await isar.habits.get(id);

    //update completion status
    if(habit != null){
      //completed? add : remove current date from the list ;
      await isar.writeTxn(() async {
        if(isCompleted && !habit.completedDays.contains(DateTime.now())){
          final today = DateTime.now();

          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day
            ),
          );
        } else {
          habit.completedDays.removeWhere(
            (date) => 
            date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day,
          );
        }
        await isar.habits.put(habit);
      }); 
    }
    //re-read
    readHabits();
  }

  //update - edit habit
  Future<void> updateHabitName(int id, String newName) async {
    //get habit from db
    final habit = await isar.habits.get(id);

    //update habit name
    if(habit != null){
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    //re-read
    readHabits();
  }

  //delete
  Future<void> deleteHabit(int id) async {
    //delete from db
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    //re-read
    readHabits();
  }
}