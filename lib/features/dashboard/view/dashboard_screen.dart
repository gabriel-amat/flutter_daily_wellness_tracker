import 'package:daily_wellness_tracker/core/routes/navigation_controller.dart';
import 'package:daily_wellness_tracker/features/entry/routes/entry_pages.dart';
import 'package:daily_wellness_tracker/features/dashboard/view/widgets/progress_card.dart';
import 'package:daily_wellness_tracker/features/dashboard/viewModel/dashboard_view_model.dart';
import 'package:daily_wellness_tracker/features/settings/viewModel/settings_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/service/consumption_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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
    final navigator = context.read<NavigationController>();

    return RefreshIndicator.adaptive(
      onRefresh: () => _dashboardViewModel.fetchDashboardData(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Consumer<DashboardViewModel>(
          builder: (context, dashborad, child) {
            if (dashborad.isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  Consumer2<SettingsViewModel, ConsumptionService>(
                    builder: (context, settings, consumptionService, child) {
                      return Column(
                        spacing: 24,
                        children: [
                          ProgressCard(
                            todayCalories: dashborad.todayCalories,
                            calorieGoal: settings.calorieGoal,
                            title: 'Today\'s Calories',
                          ),
                          ProgressCard(
                            todayCalories: dashborad.todayWater,
                            calorieGoal: settings.waterGoal,
                            title: 'Today\'s Water',
                          ),
                        ],
                      );
                    },
                  ),
                  // Add Buttons
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade200,
                          Colors.grey.shade100,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      navigator.push(routeName: EntryPages.entry);
                    },
                    icon: const Icon(Icons.restaurant),
                    label: const Text('Add Entry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  // History
                  const Text(
                    'Last 3 Days',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...dashborad.history.map(
                    (day) => Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.blueAccent,
                        ),
                        title: Text(day.date),
                        subtitle: Text(
                          'Calories: ${day.getCalories} kcal\nWater: ${day.getWater} L',
                        ),
                      ),
                    ),
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
