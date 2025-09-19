import 'dart:developer';

import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:flutter/material.dart';

class AddCalorieViewModel extends ChangeNotifier {
  final ConsumptionService _consumptionService;

  AddCalorieViewModel({required ConsumptionService consumptionService})
    : _consumptionService = consumptionService;

  bool isLoading = false;
  double todayTotalCalories = 0.0;
  List<ConsumptionItemEntity> todayEntries = [];

  Future<void> saveEntry({required double value}) async {
    isLoading = true;
    notifyListeners();

    await _consumptionService.addCalorieEntry(value);

    isLoading = false;
    notifyListeners();

    getTodayEntries();
    getTodayTotalCalories();
  }

  Future<void> getTodayTotalCalories() async {
    log('Fetching today\'s total calories');
    final res = await _consumptionService.getTodayCalories();
    todayTotalCalories = res;
    log('Today\'s total calories: $todayTotalCalories');
    notifyListeners();
  }

  Future<void> getTodayEntries() async {
    final res = await _consumptionService.getTodayCalorieEntries();
    todayEntries = res;
    notifyListeners();
  }
}
