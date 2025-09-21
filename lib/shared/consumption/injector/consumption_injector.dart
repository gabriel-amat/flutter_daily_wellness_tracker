import 'package:daily_wellness_tracker/shared/consumption/data/data_sources/meal_consumption_data_source.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/meal_consumption_service.dart';
import 'package:provider/provider.dart';

class ConsumptionInjector {
  static setup() => [
    //Data Source
    Provider(create: (_) => MealConsumptionDataSource()),

    //Service
    Provider(
      create: (context) => MealConsumptionService(
        dataSource: context.read<MealConsumptionDataSource>(),
      ),
    ),
  ];
}
