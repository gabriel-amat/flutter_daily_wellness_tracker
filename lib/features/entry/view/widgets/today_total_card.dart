import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/entry/viewModel/entry_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayTotalCard extends StatelessWidget {
  final EntryType currentType;

  const TodayTotalCard({super.key, required this.currentType});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: currentType == EntryType.calorie
                ? [AppColors.primary, AppColors.primary.withValues(alpha: 0.5)]
                : [AppColors.water, AppColors.water.withValues(alpha: 0.5)],
          ),
        ),
        child: Column(
          spacing: 12,
          children: [
            Icon(
              currentType == EntryType.calorie
                  ? Icons.local_fire_department
                  : Icons.water_drop,
              color: Colors.white,
              size: 40,
            ),
            Text(
              currentType == EntryType.calorie
                  ? 'Today\'s Total Calories'
                  : 'Today\'s Water Intake',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Consumer<EntryViewModel>(
              builder: (context, viewModel, child) {
                return Text(
                  currentType == EntryType.calorie
                      ? '${viewModel.todayTotalCalories.toStringAsFixed(0)} cal'
                      : '${viewModel.todayTotalWater.toStringAsFixed(0)} ml',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
