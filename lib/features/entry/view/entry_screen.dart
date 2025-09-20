import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/entry/view/widgets/entry_card.dart';
import 'package:daily_wellness_tracker/features/entry/viewModel/entry_view_model.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum EntryType { calorie, water }

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  late CustomSnack snack;
  late EntryViewModel viewModel;
  final entryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  EntryType selectedType = EntryType.calorie;

  @override
  void initState() {
    viewModel = context.read<EntryViewModel>();
    snack = context.read<CustomSnack>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    super.initState();
  }

  @override
  void dispose() {
    entryController.dispose();
    super.dispose();
  }

  void _loadData() {
    viewModel.getTodayTotalCalories();
    viewModel.getTodayTotalWater();
    viewModel.getTodayEntries();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: AppTheme.defaultPageMargin,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            _buildTodayTotalCard(),
            _buildEntryTypeSelector(),
            _buildAddEntryCard(),
            _buildRecentEntriesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTotalCard() {
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
            colors: selectedType == EntryType.calorie
                ? [AppColors.primary, AppColors.primaryLight]
                : [AppColors.water, AppColors.water.withValues(alpha: 0.8)],
          ),
        ),
        child: Column(
          spacing: 12,
          children: [
            Icon(
              selectedType == EntryType.calorie
                  ? Icons.local_fire_department
                  : Icons.water_drop,
              color: Colors.white,
              size: 40,
            ),
            Text(
              selectedType == EntryType.calorie
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
                  selectedType == EntryType.calorie
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

  Widget _buildEntryTypeSelector() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            const Text(
              'What would you like to add?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => selectedType = EntryType.calorie),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: selectedType == EntryType.calorie
                            ? AppColors.primary
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: selectedType == EntryType.calorie
                                ? Colors.white
                                : Colors.grey.shade600,
                            size: 20,
                          ),
                          Text(
                            'Calories',
                            style: TextStyle(
                              color: selectedType == EntryType.calorie
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedType = EntryType.water),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: selectedType == EntryType.water
                            ? AppColors.water
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: selectedType == EntryType.water
                                ? Colors.white
                                : Colors.grey.shade600,
                            size: 20,
                          ),
                          Text(
                            'Water',
                            style: TextStyle(
                              color: selectedType == EntryType.water
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddEntryCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              TextFormField(
                controller: entryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: selectedType == EntryType.calorie
                      ? 'Ex: 250'
                      : 'Ex: 500',
                  prefixIcon: Icon(
                    selectedType == EntryType.calorie
                        ? Icons.local_fire_department
                        : Icons.water_drop,
                    color: selectedType == EntryType.calorie
                        ? AppColors.primary
                        : Colors.blue.shade600,
                  ),
                  suffixText: selectedType == EntryType.calorie ? 'cal' : 'ml',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return selectedType == EntryType.calorie
                        ? 'Please enter the calories'
                        : 'Please enter the water amount';
                  }
                  if (double.parse(value) <= 0) {
                    return selectedType == EntryType.calorie
                        ? 'Calories must be greater than zero'
                        : 'Water amount must be greater than zero';
                  }
                  return null;
                },
              ),
              Consumer<EntryViewModel>(
                builder: (context, viewModel, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedType == EntryType.calorie
                            ? AppColors.primary
                            : Colors.blue.shade600,
                      ),
                      onPressed: viewModel.isLoading ? null : _onAddEntry,
                      child: viewModel.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              selectedType == EntryType.calorie
                                  ? 'Add Calories'
                                  : 'Add Water',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentEntriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'Today\'s Entries',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Consumer<EntryViewModel>(
          builder: (context, viewModel, widget) {
            final entries = viewModel.todayEntries;

            if (viewModel.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (entries.isEmpty) {
              return Center(
                child: Column(
                  spacing: 8,
                  children: [
                    Icon(Icons.info, color: Colors.grey[400]),
                    const Text(
                      'No entries today. Add the first one!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return EntryCard(item: entries[index]);
              },
            );
          },
        ),
      ],
    );
  }

  void _onAddEntry() {
    if (!_formKey.currentState!.validate()) {
      snack.error(
        text: selectedType == EntryType.calorie
            ? 'Type a valid number of calories'
            : 'Type a valid amount of water',
      );
      return;
    }

    final value = double.tryParse(entryController.text);

    if (value != null) {
      if (selectedType == EntryType.calorie) {
        viewModel.saveCalorieEntry(value: value);
        snack.success(text: '${value.toStringAsFixed(0)} calories added!');
      } else {
        viewModel.saveWaterEntry(value: value);
        snack.success(text: '${value.toStringAsFixed(0)} ml of water added!');
      }
      entryController.clear();
    }
  }
}
