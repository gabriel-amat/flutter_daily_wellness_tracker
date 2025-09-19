import 'package:daily_wellness_tracker/shared/consumption/dao/consumption_dao.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:provider/provider.dart';

class ConsumptionInjector {
  static setup() => [
    //Dao
    Provider(create: (_) => ConsumptionDao()),

    //Service
    Provider(
      create: (context) =>
          ConsumptionService(consumptionDao: context.read<ConsumptionDao>()),
    ),
  ];
}
