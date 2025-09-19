import 'dart:developer';

import 'package:daily_wellness_tracker/core/database/db_helper.dart';

class SettingsDao {
  static const String _calorieGoalKey = 'calorie_goal';
  static const String _waterGoalKey = 'water_goal';

  Future<void> storeCalorieGoal(double goal) async {
    final prefs = await DBHelper.prefs;
    prefs.setDouble(_calorieGoalKey, goal);
  }

  Future<double?> fetchCalorieGoal() async {
    log('Fetch calorie goal');
    final prefs = await DBHelper.prefs;
    return prefs.getDouble(_calorieGoalKey);
  }

  Future<double?> fetchWaterGoal() async {
    log('Fetch water goal');
    final prefs = await DBHelper.prefs;
    return prefs.getDouble(_waterGoalKey);
  }

  Future<void> storeWaterGoal(double goal) async {
    final prefs = await DBHelper.prefs;
    prefs.setDouble(_waterGoalKey, goal);
  }
}
