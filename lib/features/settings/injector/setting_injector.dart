import 'package:daily_wellness_tracker/features/settings/data/data_sources/settings_data_source.dart';
import 'package:daily_wellness_tracker/features/settings/data/repositories/settings_repository.dart';
import 'package:daily_wellness_tracker/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:daily_wellness_tracker/features/settings/presentation/viewModel/settings_view_model.dart';
import 'package:provider/provider.dart';

class SettingInjector {
  static setup() => [
    //Dao
    Provider<SettingsDataSouce>(create: (_) => SettingsDataSouce()),

    //Repository
    Provider<ISettingsRepository>(
      create: (context) =>
          SettingsRepository(dataSource: context.read<SettingsDataSouce>()),
    ),

    //Controller
    ChangeNotifierProvider(
      create: (context) =>
          SettingsViewModel(repository: context.read<ISettingsRepository>()),
    ),
  ];
}
