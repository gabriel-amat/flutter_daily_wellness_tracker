import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:daily_wellness_tracker/features/entry/viewModel/entry_view_model.dart';
import 'package:provider/provider.dart';

class EntryInjector {
  static setup() => [
    ChangeNotifierProvider(
      create: (context) => EntryViewModel(
        consumptionService: context.read<ConsumptionService>(),
      ),
    ),
  ];
}
