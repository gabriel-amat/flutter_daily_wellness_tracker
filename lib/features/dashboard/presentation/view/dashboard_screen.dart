import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/history/presentation/view/widgets/history_item.dart';
import 'package:daily_wellness_tracker/features/dashboard/presentation/view/widgets/progress_card.dart';
import 'package:daily_wellness_tracker/features/dashboard/presentation/viewModel/dashboard_view_model.dart';
import 'package:daily_wellness_tracker/features/settings/presentation/viewModel/settings_view_model.dart';
import 'package:daily_wellness_tracker/shared/ui/widgets/empty_list.dart';
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
                        todayMeals: dashboard.todayMeals,
                        mealGoal: settings.mealGoal,
                        entryType: EntryType.meal,
                      ),
                      ProgressCard(
                        todayMeals: dashboard.todayWater,
                        mealGoal: settings.waterGoal,
                        entryType: EntryType.water,
                      ),
                    ],
                  ),
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
                        "Add meal or water",
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
                  //Recent entries
                  if (dashboard.hasHistory) ...[
                    _buildHistoryList(dashboard),
                  ] else ...[
                    EmptyList(text: 'No recent entries'),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryList(DashboardViewModel dashboard) {
    final List<Map<String, dynamic>> allEntries = [];

    for (final meal in dashboard.mealHistory) {
      allEntries.add({'type': 'meal', 'data': meal});
    }

    for (final waterEntry in dashboard.waterHistory) {
      allEntries.add({'type': 'water', 'data': waterEntry});
    }

    allEntries.sort((a, b) => b['data'].date.compareTo(a['data'].date));

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allEntries.length >= 3 ? 3 : allEntries.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: HistoryItem(entry: allEntries[index]),
        );
      },
    );
  }
}
