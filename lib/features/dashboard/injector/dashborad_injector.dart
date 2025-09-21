import 'package:daily_wellness_tracker/features/dashboard/presentation/viewModel/dashboard_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/meal_consumption_service.dart';
import 'package:provider/provider.dart';

class DashboardInjector {
  static setup() => [
    //Controller
    ChangeNotifierProvider(
      create: (context) => DashboardViewModel(
        repository: context.read<MealConsumptionService>(),
      ),
    ),
  ];
}
