import 'package:daily_wellness_tracker/features/settings/data/data_sources/settings_data_source.dart';
import 'package:daily_wellness_tracker/features/settings/domain/repositories/i_settings_repository.dart';

class SettingsRepository implements ISettingsRepository {
  final SettingsDataSouce dataSource;

  SettingsRepository({required this.dataSource});

  @override
  Future<void> storeMealGoal({required double value}) async =>
      await dataSource.storeMealGoal(value);

  @override
  Future<double?> fetchMealGoal() async => await dataSource.fetchMealGoal();

  @override
  Future<void> storeWaterGoal({required double value}) async =>
      await dataSource.storeWaterGoal(value);

  @override
  Future<double?> fetchWaterGoal() async => await dataSource.fetchWaterGoal();
}
