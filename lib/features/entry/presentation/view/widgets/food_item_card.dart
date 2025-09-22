import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/food_item_entity.dart';
import 'package:flutter/material.dart';

class FoodItemCard extends StatelessWidget {
  final FoodEntity food;
  final VoidCallback onRemove;

  const FoodItemCard({super.key, required this.food, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.restaurant, color: AppColors.primary),
        ),
        title: Text(food.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${food.portions} × ${food.portionUnit} = ${food.totalCalories.toStringAsFixed(0)} kcal',
            ),
            if (food.totalCarbs > 0 ||
                food.totalProtein > 0 ||
                food.totalFat > 0)
              Text(
                'C: ${food.totalCarbs.toStringAsFixed(1)}g, P: ${food.totalProtein.toStringAsFixed(1)}g, F: ${food.totalFat.toStringAsFixed(1)}g',
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
