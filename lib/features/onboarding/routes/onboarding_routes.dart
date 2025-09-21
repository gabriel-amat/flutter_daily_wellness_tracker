import 'package:daily_wellness_tracker/features/onboarding/routes/onboarding_pages.dart';
import 'package:daily_wellness_tracker/features/onboarding/presentation/view/onboarding_screen.dart';

class OnboardingRoutes {
  static final routes = {
    OnboardingPages.onboarding: (context) => const OnboardingScreen(),
  };
}
