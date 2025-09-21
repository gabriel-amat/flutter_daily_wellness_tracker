import 'package:daily_wellness_tracker/core/constants/app_constants.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_text_style.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/settings/presentation/viewModel/settings_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/meal_consumption_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsViewModel viewModel;
  late MealConsumptionService mealConsumptionService;

  @override
  void initState() {
    viewModel = context.read<SettingsViewModel>();
    mealConsumptionService = context.read<MealConsumptionService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadSettings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppTheme.defaultPageMargin,
      child: SingleChildScrollView(
        child: Consumer<SettingsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text("Settings", style: AppTextStyle.bigTitle),
                SizedBox(height: 16),

                const Text("Meals goal settings"),

                Slider(
                  value: viewModel.mealGoal,
                  min: AppConstants.minMealGoal,
                  max: AppConstants.maxMealGoal,
                  divisions: 10,
                  label: '${viewModel.mealGoal.toInt()} kcal',
                  onChanged: (double value) {
                    viewModel.storeMealGoal(value);
                  },
                ),

                const Text("Water goal settings"),

                Slider(
                  value: viewModel.waterGoal,
                  min: AppConstants.minWaterGoal,
                  max: AppConstants.maxWaterGoal,
                  divisions: 10,
                  label: '${viewModel.waterGoal.toInt()} ml',
                  onChanged: (double value) {
                    viewModel.storeWaterGoal(value);
                  },
                ),
                const Divider(thickness: 0.5, color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delete data"),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      onPressed: () {
                        mealConsumptionService.clearAllData();
                      },
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: AppColors.primary,
                      ),
                      label: const Text("Delete"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
