import 'package:daily_wellness_tracker/core/constants/app_constants.dart';
import 'package:daily_wellness_tracker/features/settings/database/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _repository;

  SettingsViewModel({required SettingsRepository repository})
    : _repository = repository;

  double waterGoal = AppConstants.minWaterGoal;
  double calorieGoal = AppConstants.minCalorieGoal;
  bool isLoading = false;

  Future<void> storeCalorieGoal(double goal) async {
    calorieGoal = goal;
    notifyListeners();
    await _repository.storeCalorieGoal(goal);
  }

  Future<void> storeWaterGoal(double goal) async {
    waterGoal = goal;
    notifyListeners();
    await _repository.storeWaterGoal(goal);
  }

  Future<void> loadSettings() async {
    isLoading = true;
    notifyListeners();

    await Future.wait([_fetchCalorieGoal(), _fetchWaterGoal()]);
    isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchCalorieGoal() async {
    final res = await _repository.fetchCalorieGoal();
    calorieGoal = res ?? AppConstants.minCalorieGoal;
  }

  Future<void> _fetchWaterGoal() async {
    final res = await _repository.fetchWaterGoal();
    waterGoal = res ?? AppConstants.minWaterGoal;
  }
}
