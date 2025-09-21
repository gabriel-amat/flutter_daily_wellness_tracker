import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/dashboard/view/widgets/progress_card.dart';
import 'package:daily_wellness_tracker/features/dashboard/viewModel/dashboard_view_model.dart';
import 'package:daily_wellness_tracker/features/history/view/widgets/history_card.dart';
import 'package:daily_wellness_tracker/features/settings/viewModel/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int page) goToPage;
  const DashboardScreen({super.key, required this.goToPage});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardViewModel _dashboardViewModel;
  late final SettingsViewModel _settingsViewModel;

  @override
  void initState() {
    _dashboardViewModel = context.read<DashboardViewModel>();
    _settingsViewModel = context.read<SettingsViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dashboardViewModel.fetchDashboardData();
      _settingsViewModel.loadSettings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => _dashboardViewModel.fetchDashboardData(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Consumer2<DashboardViewModel, SettingsViewModel>(
          builder: (context, dashboard, settings, child) {
            if (dashboard.isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  // Progress Cards
                  Column(
                    spacing: 24,
                    children: [
                      ProgressCard(
                        todayCalories: dashboard.todayCalories,
                        calorieGoal: settings.calorieGoal,
                        entryType: EntryType.calorie,
                      ),
                      ProgressCard(
                        todayCalories: dashboard.todayWater,
                        calorieGoal: settings.waterGoal,
                        entryType: EntryType.water,
                      ),
                    ],
                  ),
                  // Add Buttons
                  InkWell(
                    onTap: () {
                      widget.goToPage(1);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.water],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Text(
                        "Add calorie or water",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Last 3 Days',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  //Last 3 days history
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dashboard.history.length >= 3
                        ? 3
                        : dashboard.history.length,
                    itemBuilder: (context, index) {
                      return HistoryCard(
                        item: dashboard.history[index],
                        canEdit: false,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
