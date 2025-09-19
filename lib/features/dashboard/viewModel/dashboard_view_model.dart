import 'dart:developer';
import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';
import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  final ConsumptionService _consumptionService;

  DashboardViewModel({required ConsumptionService repository})
    : _consumptionService = repository;

  double calorieGoal = 2200.0;
  double waterGoal = 2.5;

  double todayCalories = 0.0;
  double todayWater = 0.0;
  List<ConsumptionItemEntity> history = [];

  bool isLoading = false;

  double get calorieProgress =>
      calorieGoal == 0 ? 0 : todayCalories / calorieGoal;
  double get waterProgress => waterGoal == 0 ? 0 : todayWater / waterGoal;

  Future<void> fetchDashboardData() async {
    log('Fetching dashboard data...');

    isLoading = true;
    notifyListeners();

    history = await _consumptionService.getAllHistory();

    isLoading = false;

    if (history.isEmpty) {
      todayCalories = 0.0;
      todayWater = 0.0;
      notifyListeners();
      return;
    }

    todayCalories = history
        .where((item) => item.type == ConsumptionType.calories)
        .fold(0.0, (sum, item) => sum + item.value);

    todayWater = history
        .where((item) => item.type == ConsumptionType.water)
        .fold(0.0, (sum, item) => sum + item.value);

    notifyListeners();
  }
}
