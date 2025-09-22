import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/water_intake_entity.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final Map<String, dynamic> entry;

  const HistoryItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final type = entry['type'] as String;
    final data = entry['data'];

    if (type == 'meal') {
      final meal = data as MealEntity;
      return Card(
        child: ListTile(
          leading: const Icon(Icons.restaurant, color: Colors.orange),
          title: Text(meal.name),
          subtitle: Text('${meal.foods.length} food items'),
          trailing: Text('${meal.totalCalories.toStringAsFixed(0)} cal'),
        ),
      );
    } else {
      final waterEntry = data as WaterIntakeEntity;
      return Card(
        child: ListTile(
          leading: const Icon(Icons.water_drop, color: Colors.blue),
          title: const Text('Water Entry'),
          trailing: Text('${waterEntry.amount.toStringAsFixed(0)} ml'),
        ),
      );
    }
  }
}
