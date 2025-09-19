import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:daily_wellness_tracker/features/history/viewModel/history_view_model.dart';
import 'package:provider/provider.dart';

class HistoryInjector {
  static setup() => [
    ChangeNotifierProvider(
      create: (context) => HistoryViewModel(
        consumptionService: context.read<ConsumptionService>(),
      ),
    ),
  ];
}
