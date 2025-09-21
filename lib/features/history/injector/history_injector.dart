import 'package:daily_wellness_tracker/shared/consumption/service/meal_consumption_service.dart';
import 'package:daily_wellness_tracker/features/history/presentation/viewModel/history_view_model.dart';
import 'package:provider/provider.dart';

class HistoryInjector {
  static setup() => [
    ChangeNotifierProvider(
      create: (context) => HistoryViewModel(
        mealConsumptionService: context.read<MealConsumptionService>(),
      ),
    ),
  ];
}
