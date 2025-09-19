import 'package:daily_wellness_tracker/features/settings/database/dao/settings_dao.dart';
import 'package:daily_wellness_tracker/features/settings/database/repositories/settings_repository.dart';
import 'package:daily_wellness_tracker/features/settings/viewModel/settings_view_model.dart';
import 'package:provider/provider.dart';

class SettingInjector {
  static setup() => [
    //Dao
    Provider(create: (_) => SettingsDao()),

    //Repository
    Provider(
      create: (context) => SettingsRepository(dao: context.read<SettingsDao>()),
    ),

    //Controller
    ChangeNotifierProvider(
      create: (context) =>
          SettingsViewModel(repository: context.read<SettingsRepository>()),
    ),
  ];
}
