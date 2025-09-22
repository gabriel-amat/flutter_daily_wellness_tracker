import 'dart:convert';
import 'dart:developer';
import 'package:daily_wellness_tracker/core/database/db_helper.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/water_intake_entity.dart';

class MealConsumptionDataSource {
  static const String _mealsKey = 'meals_data';
  static const String _waterKey = 'water_data';

  Future<void> addMeal(MealEntity meal) async {
    final prefs = await DBHelper.prefs;
    meal.id ??= DateTime.now().millisecondsSinceEpoch.toDouble();

    final existingMeals = await getAllMeals();
    existingMeals.add(meal);

    final mealsJson = existingMeals.map((e) => e.toJson()).toList();
    await prefs.setString(_mealsKey, json.encode(mealsJson));
    log('Added meal: ${meal.name} with ${meal.foods.length} items');
  }

  Future<List<MealEntity>> getAllMeals() async {
    final prefs = await DBHelper.prefs;
    final mealsString = prefs.getString(_mealsKey);

    if (mealsString == null) return [];

    final mealsList = json.decode(mealsString) as List;
    return mealsList.map((meal) => MealEntity.fromJson(meal)).toList();
  }

  Future<List<MealEntity>> getMealsByDate(String date) async {
    final allMeals = await getAllMeals();
    return allMeals.where((meal) => meal.date.startsWith(date)).toList();
  }

  Future<MealEntity?> getMealById(double id) async {
    final allMeals = await getAllMeals();
    try {
      return allMeals.firstWhere((meal) => meal.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateMeal(MealEntity meal) async {
    final prefs = await DBHelper.prefs;
    final existingMeals = await getAllMeals();

    final index = existingMeals.indexWhere((m) => m.id == meal.id);
    if (index != -1) {
      existingMeals[index] = meal;
      final mealsJson = existingMeals.map((e) => e.toJson()).toList();
      await prefs.setString(_mealsKey, json.encode(mealsJson));
      log('Updated meal: ${meal.name}');
    }
  }

  Future<void> removeMeal(MealEntity meal) async {
    final prefs = await DBHelper.prefs;
    final existingMeals = await getAllMeals();

    existingMeals.removeWhere((m) => m.id == meal.id);
    final mealsJson = existingMeals.map((e) => e.toJson()).toList();
    await prefs.setString(_mealsKey, json.encode(mealsJson));
    log('Removed meal: ${meal.name}');
  }

  Future<double> getTotalCaloriesByDate(String date) async {
    final meals = await getMealsByDate(date);
    return meals.fold<double>(0.0, (total, meal) => total + meal.totalCalories);
  }

  Future<double> getTotalCarbsByDate(String date) async {
    final meals = await getMealsByDate(date);
    return meals.fold<double>(0.0, (total, meal) => total + meal.totalCarbs);
  }

  Future<double> getTotalProteinByDate(String date) async {
    final meals = await getMealsByDate(date);
    return meals.fold<double>(0.0, (total, meal) => total + meal.totalProtein);
  }

  Future<double> getTotalFatByDate(String date) async {
    final meals = await getMealsByDate(date);
    return meals.fold<double>(0.0, (total, meal) => total + meal.totalFat);
  }

  // WATER
  Future<void> addWaterEntry(WaterIntakeEntity waterItem) async {
    final prefs = await DBHelper.prefs;
    waterItem.id ??= DateTime.now().millisecondsSinceEpoch.toDouble();

    final existingWater = await getAllWaterEntries();
    existingWater.add(waterItem);

    final waterJson = existingWater.map((e) => e.toJson()).toList();
    await prefs.setString(_waterKey, json.encode(waterJson));
    log('add water entry: ${waterItem.amount}');
  }

  Future<List<WaterIntakeEntity>> getAllWaterEntries() async {
    final prefs = await DBHelper.prefs;
    final waterString = prefs.getString(_waterKey);

    if (waterString == null) return [];

    final waterList = json.decode(waterString) as List;
    return waterList.map((item) => WaterIntakeEntity.fromJson(item)).toList();
  }

  Future<List<WaterIntakeEntity>> getWaterEntriesByDate(String date) async {
    final allWater = await getAllWaterEntries();
    return allWater.where((item) => item.date.startsWith(date)).toList();
  }

  Future<double> getTotalWaterByDate(String date) async {
    final waterEntries = await getWaterEntriesByDate(date);
    return waterEntries.fold<double>(0.0, (total, item) => total + item.amount);
  }

  Future<void> removeWaterEntry(WaterIntakeEntity waterItem) async {
    final prefs = await DBHelper.prefs;
    final existingWater = await getAllWaterEntries();

    existingWater.removeWhere((item) => item.id == waterItem.id);
    final waterJson = existingWater.map((e) => e.toJson()).toList();
    await prefs.setString(_waterKey, json.encode(waterJson));
  }

  Future<void> clearAllData() async {
    final prefs = await DBHelper.prefs;
    await prefs.remove(_mealsKey);
    await prefs.remove(_waterKey);
    log('Cleared all consumption data');
  }
}
