import 'dart:developer';

import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/water_intake_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/meal_consumption_service.dart';
import 'package:flutter/material.dart';

class EntryViewModel extends ChangeNotifier {
  final MealConsumptionService _mealConsumptionService;

  EntryViewModel({required MealConsumptionService mealConsumptionService})
    : _mealConsumptionService = mealConsumptionService;

  bool isLoading = false;
  double todayTotalCalories = 0.0;
  double todayTotalWater = 0.0;
  List<MealEntity> todayMeals = [];
  List<WaterIntakeEntity> todayWaterEntries = [];

  Future<void> saveMeal({required MealEntity meal}) async {
    isLoading = true;
    notifyListeners();

    await _mealConsumptionService.addMeal(meal);

    isLoading = false;
    notifyListeners();

    getTodayData();
  }

  Future<void> updateMeal({required MealEntity meal}) async {
    isLoading = true;
    notifyListeners();

    await _mealConsumptionService.updateMeal(meal);

    isLoading = false;
    notifyListeners();

    getTodayData();
  }

  Future<void> removeMeal({required MealEntity meal}) async {
    isLoading = true;
    notifyListeners();

    await _mealConsumptionService.removeMeal(meal);

    isLoading = false;
    notifyListeners();

    getTodayData();
  }

  Future<void> saveWaterEntry({required double milliliters}) async {
    isLoading = true;
    notifyListeners();

    await _mealConsumptionService.addWaterEntry(milliliters);

    isLoading = false;
    notifyListeners();

    getTodayData();
  }

  Future<void> removeWaterEntry({required WaterIntakeEntity waterEntry}) async {
    isLoading = true;
    notifyListeners();

    await _mealConsumptionService.removeWaterEntry(waterEntry);

    isLoading = false;
    notifyListeners();

    getTodayData();
  }

  Future<void> getTodayTotalCalories() async {
    log('Fetching total calories');
    final res = await _mealConsumptionService.getTodayCalories();
    todayTotalCalories = res;
    log('Today total calories: $todayTotalCalories');
    notifyListeners();
  }

  Future<void> getTodayTotalWater() async {
    log('Fetching total water');
    final res = await _mealConsumptionService.getTodayWater();
    todayTotalWater = res;
    log('Today total water: $todayTotalWater');
    notifyListeners();
  }

  Future<void> getTodayMeals() async {
    log('Fetching today meals');
    todayMeals = await _mealConsumptionService.getTodayMeals();
    log('Today meals count: ${todayMeals.length}');
    notifyListeners();
  }

  Future<void> getTodayWaterEntries() async {
    log('Fetching today water entries');
    todayWaterEntries = await _mealConsumptionService.getTodayWaterEntries();
    log('Today water entries count: ${todayWaterEntries.length}');
    notifyListeners();
  }

  Future<void> getTodayData() async {
    await Future.wait([
      getTodayTotalCalories(),
      getTodayTotalWater(),
      getTodayMeals(),
      getTodayWaterEntries(),
    ]);
  }
}
