import 'package:daily_wellness_tracker/features/entry/routes/entry_routes.dart';
import 'package:daily_wellness_tracker/features/home/routes/home_routes.dart';
import 'package:daily_wellness_tracker/features/onboarding/routes/onboarding_routes.dart';
import 'package:daily_wellness_tracker/features/onboarding/routes/onboarding_pages.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final allRoutes = {
      ...HomeRoutes.getRoutes(settings),
      ...EntryRoutes.getRoutes(settings),
      ...OnboardingRoutes.routes,
    };

    final builder = allRoutes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(builder: allRoutes[OnboardingPages.onboarding]!);
  }
}
