import 'dart:developer';
import 'package:daily_wellness_tracker/core/helper/format_data.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/data_sources/meal_consumption_data_source.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/water_intake_entity.dart';

class MealConsumptionService {
  final MealConsumptionDataSource _dataSource;

  MealConsumptionService({required MealConsumptionDataSource dataSource})
    : _dataSource = dataSource;

  // MEAL
  Future<void> addMeal(MealEntity meal) async {
    meal.date = FormatDate.dateTimeToString(DateTime.now());
    log('Adding meal: ${meal.name}');
    await _dataSource.addMeal(meal);
  }

  Future<List<MealEntity>> getTodayMeals() async {
    final today = FormatDate.dateTimeToString(DateTime.now());
    return await _dataSource.getMealsByDate(today);
  }

  Future<List<MealEntity>> getMealsByDate(String date) async {
    return await _dataSource.getMealsByDate(date);
  }

  Future<MealEntity?> getMealById(double id) async {
    return await _dataSource.getMealById(id);
  }

  Future<void> updateMeal(MealEntity meal) async {
    log('Updating meal: ${meal.name}');
    await _dataSource.updateMeal(meal);
  }

  Future<void> removeMeal(MealEntity meal) async {
    log('Removing meal: ${meal.name}');
    await _dataSource.removeMeal(meal);
  }

  Future<double> getTodayCalories() async {
    final today = FormatDate.dateTimeToString(DateTime.now());
    return await _dataSource.getTotalCaloriesByDate(today);
  }

  Future<double> getTodayCarbs() async {
    final today = FormatDate.dateTimeToString(DateTime.now());
    return await _dataSource.getTotalCarbsByDate(today);
  }

  Future<double> getTodayProtein() async {
    final today = FormatDate.dateTimeToString(DateTime.now());
    return await _dataSource.getTotalProteinByDate(today);
  }

  Future<double> getTodayFat() async {
    final today = FormatDate.dateTimeToString(DateTime.now());
    return await _dataSource.getTotalFatByDate(today);
  }

  Future<double> getCaloriesByDate(String date) async {
    return await _dataSource.getTotalCaloriesByDate(date);
  }

  // WATER OPERATIONS
  Future<void> addWaterEntry(double data) async {
    final waterEntry = WaterIntakeEntity(
      date: FormatDate.dateTimeToString(DateTime.now()),
      amount: data,
    );
    log('Adding water entry: ${data}ml');
    await _dataSource.addWaterEntry(waterEntry);
  }

  Future<double> getTodayWater() async {
    final today = FormatDate.dateTimeToString(DateTime.now());
    return await _dataSource.getTotalWaterByDate(today);
  }

  Future<List<WaterIntakeEntity>> getTodayWaterEntries() async {
    final today = FormatDate.dateTimeToString(DateTime.now());
    return await _dataSource.getWaterEntriesByDate(today);
  }

  Future<List<WaterIntakeEntity>> getAllWaterEntries() async {
    return await _dataSource.getAllWaterEntries();
  }

  Future<List<WaterIntakeEntity>> getWaterEntriesByDate(String date) async {
    return await _dataSource.getWaterEntriesByDate(date);
  }

  Future<void> updateWaterEntry(WaterIntakeEntity waterEntry) async {
    log('Updating water entry: ${waterEntry.amount}ml');
    await _dataSource.removeWaterEntry(waterEntry);
    await _dataSource.addWaterEntry(waterEntry);
  }

  Future<void> removeWaterEntry(WaterIntakeEntity waterEntry) async {
    await _dataSource.removeWaterEntry(waterEntry);
  }

  Future<List<MealEntity>> getAllMeals() async {
    return await _dataSource.getAllMeals();
  }

  Future<void> clearAllData() async {
    await _dataSource.clearAllData();
  }
}
