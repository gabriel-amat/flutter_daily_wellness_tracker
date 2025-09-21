import 'package:daily_wellness_tracker/features/onboarding/presentation/viewModel/onboarding_view_model.dart';
import 'package:provider/provider.dart';

class OnboardingInjector {
  static setup() => [
    ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
  ];
}
