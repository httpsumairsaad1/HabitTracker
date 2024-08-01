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
} 
