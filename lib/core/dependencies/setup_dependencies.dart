import 'package:daily_wellness_tracker/features/history/injector/history_injector.dart';
import 'package:daily_wellness_tracker/shared/consumption/injector/consumption_injector.dart';
import 'package:daily_wellness_tracker/core/routes/navigation_controller.dart';
import 'package:daily_wellness_tracker/features/entry/injector/entry_injector.dart';
import 'package:daily_wellness_tracker/features/dashboard/injector/dashborad_injector.dart';
import 'package:daily_wellness_tracker/features/onboarding/injector/onboarding_injector.dart';
import 'package:daily_wellness_tracker/features/settings/injector/setting_injector.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> setupDependencies() {
  return [
    Provider<CustomSnack>(create: (_) => CustomSnack()),

    Provider<NavigationController>(create: (_) => NavigationController()),

    //Dependencies from other features
    ...ConsumptionInjector.setup(),
    ...EntryInjector.setup(),
    ...OnboardingInjector.setup(),
    ...DashboardInjector.setup(),
    ...SettingInjector.setup(),
    ...HistoryInjector.setup(),
  ];
}
