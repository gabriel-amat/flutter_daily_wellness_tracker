import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:daily_wellness_tracker/features/addCalorie/viewModel/add_calorie_view_model.dart';
import 'package:provider/provider.dart';

class AddCalorieInjector {
  static setup() => [
    ChangeNotifierProvider(
      create: (context) => AddCalorieViewModel(
        consumptionService: context.read<ConsumptionService>(),
      ),
    ),
  ];
}
