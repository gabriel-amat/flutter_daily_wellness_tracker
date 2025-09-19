import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/addCalorie/view/widgets/calorie_card.dart';
import 'package:daily_wellness_tracker/features/addCalorie/viewModel/add_calorie_view_model.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCalorieScreen extends StatefulWidget {
  const AddCalorieScreen({super.key});

  @override
  State<AddCalorieScreen> createState() => _AddCalorieScreenState();
}

class _AddCalorieScreenState extends State<AddCalorieScreen> {
  late CustomSnack snack;
  late AddCalorieViewModel viewModel;
  final calorieController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    viewModel = context.read<AddCalorieViewModel>();
    snack = context.read<CustomSnack>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getTodayTotalCalories();
      viewModel.getTodayEntries();
    });
    super.initState();
  }

  @override
  void dispose() {
    calorieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        viewModel.getTodayTotalCalories();
        viewModel.getTodayEntries();
      },
      child: SingleChildScrollView(
        padding: AppTheme.defaultPageMargin,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            _buildTodayTotalCard(),
            _buildAddCalorieCard(),
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: Column(
          spacing: 12,
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 40,
            ),
            const Text(
              'Today\'s Total Calories',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Consumer<AddCalorieViewModel>(
              builder: (context, viewModel, child) {
                return Text(
                  '${viewModel.todayTotalCalories.toStringAsFixed(0)} cal',
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

  Widget _buildAddCalorieCard() {
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
                controller: calorieController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Ex: 250',
                  prefixIcon: const Icon(
                    Icons.local_fire_department,
                    color: AppColors.primary,
                  ),
                  suffixText: 'cal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the calories';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Calories must be greater than zero';
                  }
                  return null;
                },
              ),
              Consumer<AddCalorieViewModel>(
                builder: (context, viewModel, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _onAddCalories,
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
                          : const Text(
                              'Add Calories',
                              style: TextStyle(
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
        Consumer<AddCalorieViewModel>(
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
                return CalorieCard(item: entries[index]);
              },
            );
          },
        ),
      ],
    );
  }

  void _onAddCalories() {
    if (!_formKey.currentState!.validate()) {
      snack.error(text: 'Type a valid number of calories');
      return;
    }

    final calories = double.tryParse(calorieController.text);

    if (calories != null) {
      viewModel.saveEntry(value: calories);
      calorieController.clear();
      snack.success(text: '${calories.toStringAsFixed(0)} calories added!');
    }
  }
}
