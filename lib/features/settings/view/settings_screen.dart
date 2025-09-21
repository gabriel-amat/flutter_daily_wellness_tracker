import 'package:daily_wellness_tracker/core/constants/app_constants.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_text_style.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/settings/viewModel/settings_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsViewModel viewModel;
  late ConsumptionService consumptionService;

  @override
  void initState() {
    viewModel = context.read<SettingsViewModel>();
    consumptionService = context.read<ConsumptionService>();
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

                const Text("Calories goal settings"),

                Slider(
                  value: viewModel.calorieGoal,
                  min: AppConstants.minCalorieGoal,
                  max: AppConstants.maxCalorieGoal,
                  divisions: 10,
                  label: '${viewModel.calorieGoal.toInt()} kcal',
                  onChanged: (double value) {
                    viewModel.storeCalorieGoal(value);
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
                        consumptionService.clearAllData();
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
