import 'package:daily_wellness_tracker/core/dependencies/setup_dependencies.dart';
import 'package:daily_wellness_tracker/core/routes/navigation_controller.dart';
import 'package:daily_wellness_tracker/core/routes/routes.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/onboarding/routes/onboarding_pages.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: setupDependencies(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Daily Wellness ',
            theme: AppTheme.lightTheme,
            scaffoldMessengerKey: context.read<CustomSnack>().snackbarKey,
            //Route config
            initialRoute: OnboardingPages.onboarding,
            onGenerateRoute: CustomRouter.generateRoute,
            navigatorKey: context.read<NavigationController>().navigatorKey,
          );
        },
      ),
    );
  }
}
