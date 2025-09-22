import 'package:daily_wellness_tracker/features/home/routes/home_pages.dart';
import 'package:daily_wellness_tracker/features/home/presentation/view/home_screen.dart';
import 'package:flutter/material.dart';

class HomeRoutes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings settings) {
    return {HomePages.home: (context) => HomeScreen()};
  }
}
