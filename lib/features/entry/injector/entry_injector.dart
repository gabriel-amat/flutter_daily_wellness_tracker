import 'package:daily_wellness_tracker/shared/consumption/service/meal_consumption_service.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/viewModel/entry_view_model.dart';
import 'package:provider/provider.dart';

class EntryInjector {
  static setup() => [
    ChangeNotifierProvider(
      create: (context) => EntryViewModel(
        mealConsumptionService: context.read<MealConsumptionService>(),
      ),
    ),
  ];
}
