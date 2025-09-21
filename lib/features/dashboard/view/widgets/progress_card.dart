import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final double todayCalories;
  final double calorieGoal;
  final EntryType entryType;

  const ProgressCard({
    super.key,
    required this.todayCalories,
    required this.calorieGoal,
    required this.entryType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entryType == EntryType.calorie ? "Today's Calories" : "Today's Water",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: todayCalories / calorieGoal,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              color: entryType == EntryType.calorie ? AppColors.calorie : AppColors.water,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            const SizedBox(height: 8),
            Text(
              '$todayCalories / $calorieGoal ${entryType == EntryType.calorie ? 'cal' : 'ml'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
