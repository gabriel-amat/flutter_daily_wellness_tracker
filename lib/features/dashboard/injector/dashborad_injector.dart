import 'package:daily_wellness_tracker/features/dashboard/viewModel/dashboard_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:provider/provider.dart';

class DashboardInjector {
  static setup() => [
    //Controller
    ChangeNotifierProvider(
      create: (context) =>
          DashboardViewModel(repository: context.read<ConsumptionService>()),
    ),
  ];
}
