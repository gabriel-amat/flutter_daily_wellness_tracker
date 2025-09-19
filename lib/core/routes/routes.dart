import 'package:daily_wellness_tracker/features/addCalorie/routes/add_calorie_routes.dart';
import 'package:daily_wellness_tracker/features/home/routes/home_routes.dart';
import 'package:daily_wellness_tracker/features/onboarding/routes/onboarding_routes.dart';
import 'package:daily_wellness_tracker/features/onboarding/routes/onboarding_pages.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final allRoutes = {
      ...HomeRoutes.routes,
      ...AddCalorieRoutes.routes,
      ...OnboardingRoutes.routes,
      //
    };

    final builder = allRoutes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    // Fallback para onboarding se a rota não for encontrada
    return MaterialPageRoute(builder: allRoutes[OnboardingPages.onboarding]!);
  }
}
