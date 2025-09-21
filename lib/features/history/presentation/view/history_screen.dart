import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_text_style.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/history/presentation/view/widgets/filter_section_widget.dart';
import 'package:daily_wellness_tracker/features/history/presentation/view/widgets/statistics_card.dart';
import 'package:daily_wellness_tracker/features/history/presentation/viewModel/history_view_model.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryViewModel historyViewModel;
  late final CustomSnack customSnack;

  @override
  void initState() {
    historyViewModel = context.read<HistoryViewModel>();
    customSnack = context.read<CustomSnack>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    super.initState();
  }

  _loadData() {
    historyViewModel.loadAllHistory();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final availableDates = historyViewModel.getAvailableDates();

    if (availableDates.isEmpty) {
      customSnack.error(text: 'Any history data available');
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (picked != null) {
      historyViewModel.loadHistoryByDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDatePicker(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.calendar_today, color: Colors.white),
      ),
      body: Padding(
        padding: AppTheme.defaultPageMargin,
        child: RefreshIndicator.adaptive(
          onRefresh: () async => _loadData(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Consumer<HistoryViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("History", style: AppTextStyle.bigTitle),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.filter_list,
                            color: AppColors.primary,
                          ),
                          onSelected: (String result) => switch (result) {
                            '7' => viewModel.loadRecentHistory(7),
                            '30' => viewModel.loadRecentHistory(30),
                            'all' => viewModel.loadAllHistory(),
                            'clear_filters' => viewModel.clearFilters(),
                            _ => throw UnimplementedError(),
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem<String>(
                              value: '7',
                              child: Text('Last 7 days'),
                            ),
                            const PopupMenuItem<String>(
                              value: '30',
                              child: Text('Last 30 days'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'all',
                              child: Text('All records'),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem<String>(
                              value: 'clear_filters',
                              child: Text('Clear filters'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    FilterSection(historyViewModel: historyViewModel),
                    if (viewModel.hasFilteredData)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: StatisticsCard(stats: viewModel.getStatistics()),
                      ),

                    _buildHistoryContent(viewModel),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryContent(HistoryViewModel viewModel) {
    if (viewModel.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
            Text('Loading history...'),
          ],
        ),
      );
    }

    if (!viewModel.hasFilteredData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            Text(
              'No records found',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            Text('Start by adding meals or water'),
          ],
        ),
      );
    }

    // Create a combined list of entries with their types
    final List<dynamic> allEntries = [];

    // Add meal entries
    for (final meal in viewModel.filteredMeals) {
      allEntries.add({'type': 'meal', 'data': meal});
    }

    // Add water entries
    for (final waterEntry in viewModel.filteredWaterEntries) {
      allEntries.add({'type': 'water', 'data': waterEntry});
    }

    // Sort by date (newest first) - assuming both entities have date strings
    allEntries.sort((a, b) {
      final aDate = a['type'] == 'meal'
          ? (a['data'] as dynamic).date
          : (a['data'] as dynamic).date;
      final bDate = b['type'] == 'meal'
          ? (b['data'] as dynamic).date
          : (b['data'] as dynamic).date;
      return bDate.compareTo(aDate);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: allEntries.length,
      itemBuilder: (context, index) {
        final entry = allEntries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildHistoryItem(entry),
        );
      },
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> entry) {
    final type = entry['type'] as String;
    final data = entry['data'];

    if (type == 'meal') {
      final meal = data as dynamic; // MealEntity
      return Card(
        child: ListTile(
          leading: const Icon(Icons.restaurant, color: Colors.orange),
          title: Text(meal.name),
          subtitle: Text('${meal.foods.length} food items'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${meal.totalCalories.toStringAsFixed(0)} cal'),
              Text(
                meal.date.split(' ')[0],
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          onTap: () {
            // TODO: Navigate to meal details or show meal info
          },
        ),
      );
    } else {
      final waterEntry = data as dynamic; // WaterIntakeEntity
      return Card(
        child: ListTile(
          leading: const Icon(Icons.water_drop, color: Colors.blue),
          title: const Text('Water Entry'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${waterEntry.amount.toStringAsFixed(0)} ml'),
              Text(
                waterEntry.date.split(' ')[0],
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          onTap: () {
            // TODO: Navigate to water entry details or show edit dialog
          },
        ),
      );
    }
  }
}
