import 'dart:developer';

import 'package:daily_wellness_tracker/core/database/db_helper.dart';

class SettingsDataSouce {
  static const String _mealGoalKey = 'meal_goal';
  static const String _waterGoalKey = 'water_goal';

  Future<void> storeMealGoal(double goal) async {
    final prefs = await DBHelper.prefs;
    prefs.setDouble(_mealGoalKey, goal);
  }

  Future<double?> fetchMealGoal() async {
    log('Fetch meal goal');
    final prefs = await DBHelper.prefs;
    return prefs.getDouble(_mealGoalKey);
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
