import 'dart:developer';

import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:flutter/material.dart';

class EntryViewModel extends ChangeNotifier {
  final ConsumptionService _consumptionService;

  EntryViewModel({required ConsumptionService consumptionService})
    : _consumptionService = consumptionService;

  bool isLoading = false;
  double todayTotalCalories = 0.0;
  double todayTotalWater = 0.0;
  List<ConsumptionItemEntity> todayEntries = [];

  Future<void> saveCalorieEntry({required double value}) async {
    isLoading = true;
    notifyListeners();

    await _consumptionService.addCalorieEntry(value);

    isLoading = false;
    notifyListeners();

    getTodayEntries();
    getTodayTotalCalories();
  }

  Future<void> saveWaterEntry({required double value}) async {
    isLoading = true;
    notifyListeners();

    await _consumptionService.addWaterEntry(value);

    isLoading = false;
    notifyListeners();

    getTodayEntries();
    getTodayTotalWater();
  }

  Future<void> getTodayTotalCalories() async {
    log('Fetching today\'s total calories');
    final res = await _consumptionService.getTodayCalories();
    todayTotalCalories = res;
    log('Today\'s total calories: $todayTotalCalories');
    notifyListeners();
  }

  Future<void> getTodayTotalWater() async {
    log('Fetching today\'s total water');
    final res = await _consumptionService.getTodayWater();
    todayTotalWater = res;
    log('Today\'s total water: $todayTotalWater');
    notifyListeners();
  }

  Future<void> getTodayEntries() async {
    final calorieEntries = await _consumptionService.getTodayCalorieEntries();
    final waterEntries = await _consumptionService.getTodayWaterEntries();
    todayEntries = [...calorieEntries, ...waterEntries];
    // Sort by newest first (assuming there's a timestamp or id)
    todayEntries.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    notifyListeners();
  }
}
