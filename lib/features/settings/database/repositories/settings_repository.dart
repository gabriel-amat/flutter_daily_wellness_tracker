import 'package:daily_wellness_tracker/features/settings/database/dao/settings_dao.dart';

class SettingsRepository {
  final SettingsDao dao;

  SettingsRepository({required this.dao});

  Future<void> storeCalorieGoal(double goal) async =>
      await dao.storeCalorieGoal(goal);

  Future<double?> fetchCalorieGoal() async => await dao.fetchCalorieGoal();

  Future<void> storeWaterGoal(double goal) async =>
      await dao.storeWaterGoal(goal);

  Future<double?> fetchWaterGoal() async => await dao.fetchWaterGoal();
}
