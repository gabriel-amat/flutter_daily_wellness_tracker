import 'package:daily_wellness_tracker/core/constants/app_constants.dart';
import 'package:daily_wellness_tracker/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  final ISettingsRepository _repository;

  SettingsViewModel({required ISettingsRepository repository})
    : _repository = repository;

  double waterGoal = AppConstants.minWaterGoal;
  double mealGoal = AppConstants.minMealGoal;
  bool isLoading = false;

  Future<void> storeMealGoal(double value) async {
    mealGoal = value;
    notifyListeners();
    await _repository.storeMealGoal(value: value);
  }

  Future<void> storeWaterGoal(double value) async {
    waterGoal = value;
    notifyListeners();
    await _repository.storeWaterGoal(value: value);
  }

  Future<void> loadSettings() async {
    isLoading = true;
    notifyListeners();

    await Future.wait([_fetchMealGoal(), _fetchWaterGoal()]);
    isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchMealGoal() async {
    final res = await _repository.fetchMealGoal();
    mealGoal = res ?? AppConstants.minMealGoal;
  }

  Future<void> _fetchWaterGoal() async {
    final res = await _repository.fetchWaterGoal();
    waterGoal = res ?? AppConstants.minWaterGoal;
  }
}
