import 'dart:developer';
import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/water_intake_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/meal_consumption_service.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  final MealConsumptionService _mealConsumptionService;

  DashboardViewModel({required MealConsumptionService repository})
    : _mealConsumptionService = repository;

  double mealGoal = 0.0;
  double waterGoal = 0.0;
  double todayCalories = 0.0;
  double todayWater = 0.0;
  double totalCarbs = 0.0;
  double totalProtein = 0.0;
  double totalFats = 0.0;

  List<MealEntity> mealHistory = [];
  List<WaterIntakeEntity> waterHistory = [];

  bool isLoading = false;

  double get mealProgress => mealGoal == 0 ? 0 : todayCalories / mealGoal;
  double get waterProgress => waterGoal == 0 ? 0 : todayWater / waterGoal;
  bool get hasHistory => mealHistory.isNotEmpty || waterHistory.isNotEmpty;

  Future<void> fetchDashboardData() async {
    log('Fetching dashboard data...');

    isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _mealConsumptionService.getTodayCalories(),
        _mealConsumptionService.getTodayWater(),
        _mealConsumptionService.getTodayMeals(),
        _mealConsumptionService.getTodayWaterEntries(),
        _mealConsumptionService.getTodayCarbs(),
        _mealConsumptionService.getTodayProtein(),
        _mealConsumptionService.getTodayFat(),
      ]);

      todayCalories = results[0] as double;
      todayWater = results[1] as double;
      mealHistory = results[2] as List<MealEntity>;
      waterHistory = results[3] as List<WaterIntakeEntity>;
      totalCarbs = results[4] as double;
      totalProtein = results[5] as double;
      totalFats = results[6] as double;
    } catch (e) {
      log('Error fetching dashboard data: $e');
      todayCalories = 0.0;
      todayWater = 0.0;
      mealHistory = [];
      waterHistory = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
