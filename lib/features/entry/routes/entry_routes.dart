import 'package:daily_wellness_tracker/features/entry/presentation/view/screens/edit_meal_screen.dart';
import 'package:daily_wellness_tracker/features/entry/routes/entry_pages.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/screens/entry_screen.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:flutter/material.dart';

class EntryRoutes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings settings) {
    return {
      EntryPages.entry: (context) => EntryScreen(),
      EntryPages.editMeal: (context) {
        return EditMealScreen(mealEntity: settings.arguments as MealEntity);
      },
    };
  }
}
