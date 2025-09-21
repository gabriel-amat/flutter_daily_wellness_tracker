abstract interface class ISettingsRepository {
  Future<void> storeMealGoal({required double value});
  Future<void> storeWaterGoal({required double value});
  Future<double?> fetchMealGoal();
  Future<double?> fetchWaterGoal();
}
