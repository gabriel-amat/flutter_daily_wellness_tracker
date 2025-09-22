import 'package:daily_wellness_tracker/core/helper/format_data.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_text_style.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/view/widgets/food_item_card.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/viewModel/entry_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/food_item_entity.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealEntryCard extends StatefulWidget {
  const MealEntryCard({super.key});

  @override
  State<MealEntryCard> createState() => _MealEntryCardState();
}

class _MealEntryCardState extends State<MealEntryCard> {
  final _formKey = GlobalKey<FormState>();
  final _mealNameController = TextEditingController();
  final _foodNameController = TextEditingController();
  final _calorieController = TextEditingController();
  final _carbsController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _portionUnitController = TextEditingController();
  final _portionsController = TextEditingController();

  late EntryViewModel entryViewModel;
  late CustomSnack snack;

  final List<FoodEntity> _foodItems = [];

  final List<String> _commonPortionUnits = [
    '1 cup',
    '1 medium piece',
    '1 small piece',
    '1 large piece',
    '1 slice',
    '1 piece',
  ];

  @override
  void initState() {
    snack = context.read<CustomSnack>();
    entryViewModel = context.read<EntryViewModel>();
    super.initState();
  }

  @override
  dispose() {
    _formKey.currentState?.dispose();
    _mealNameController.dispose();
    _foodNameController.dispose();
    _calorieController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _portionUnitController.dispose();
    _portionsController.dispose();
    super.dispose();
  }

  void _onAddFood() {
    if (!_formKey.currentState!.validate()) {
      snack.error(text: 'Please fill in all required fields');
      return;
    }

    final name = _foodNameController.text.trim();
    final calories = double.tryParse(_calorieController.text) ?? 0.0;
    final carbs = double.tryParse(_carbsController.text) ?? 0.0;
    final protein = double.tryParse(_proteinController.text) ?? 0.0;
    final fat = double.tryParse(_fatController.text) ?? 0.0;
    final portionUnit = _portionUnitController.text.trim();
    final portions = double.tryParse(_portionsController.text) ?? 1.0;

    final foodItem = FoodEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      caloriesPerPortion: calories,
      carbsPerPortion: carbs,
      proteinPerPortion: protein,
      fatPerPortion: fat,
      portionUnit: portionUnit,
      portions: portions,
    );

    setState(() => _foodItems.add(foodItem));

    _clearFoodForm();
    snack.success(text: '$name added to meal!');
  }

  void _onSaveMeal() {
    if (_foodItems.isEmpty) {
      snack.error(text: 'Please add at least one food item');
      return;
    }

    final mealName = _mealNameController.text.trim();

    final meal = MealEntity(
      name: mealName,
      date: FormatDate.dateTimeToString(DateTime.now()),
      foods: List.from(_foodItems),
    );

    entryViewModel.saveMeal(meal: meal);

    final totalCalories = meal.totalCalories.toStringAsFixed(0);
    snack.success(text: '$mealName saved with $totalCalories calories!');

    _clearAllForms();
  }

  void _clearFoodForm() {
    _foodNameController.clear();
    _calorieController.clear();
    _carbsController.clear();
    _proteinController.clear();
    _fatController.clear();
    _portionUnitController.clear();
    _portionsController.clear();
  }

  void _clearAllForms() {
    _mealNameController.clear();
    _clearFoodForm();
    setState(() => _foodItems.clear());
  }

  void _removeFood(int index) {
    setState(() => _foodItems.removeAt(index));
    snack.success(text: 'Food item removed');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              TextFormField(
                controller: _mealNameController,
                decoration: InputDecoration(
                  labelText: 'Meal Name ',
                  hintText: 'Ex: Breakfast, Lunch, Dinner',
                  prefixIcon: const Icon(
                    Icons.restaurant,
                    color: AppColors.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                ),
              ),
              _buildFoodForm(),
              _buildActionButtons(),
              if (_foodItems.isNotEmpty) _buildFoodList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Food Item', style: AppTextStyle.subtitle),
        const SizedBox(height: 12),
        Column(
          spacing: 12,
          children: [
            TextFormField(
              controller: _foodNameController,
              decoration: InputDecoration(
                labelText: 'Food Name',
                hintText: 'Ex: Banana, Chicken Breast, Rice',
                prefixIcon: const Icon(
                  Icons.food_bank,
                  color: AppColors.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the food name';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: null,
              decoration: InputDecoration(
                labelText: 'Portion Unit',
                hintText: 'Select unit',
                prefixIcon: const Icon(
                  Icons.straighten,
                  color: AppColors.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
              items: _commonPortionUnits.map((unit) {
                return DropdownMenuItem<String>(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _portionUnitController.text = value;
                }
              },
            ),
            // Portions (Quantity)
            TextFormField(
              controller: _portionsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Portions',
                hintText: 'Ex: 1.5, 2, 0.5',
                prefixIcon: const Icon(Icons.numbers, color: AppColors.primary),
                helperText: 'How many portions/servings?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the number of portions';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            Row(
              spacing: 8,
              children: [
                // Calories per portion
                Expanded(
                  child: TextFormField(
                    controller: _calorieController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Calories/portion',
                      hintText: 'Ex: 100',
                      prefixIcon: const Icon(
                        Icons.local_fire_department,
                        color: AppColors.primary,
                      ),
                      suffixText: 'Kcal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _carbsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Carbs/portion',
                      hintText: 'Ex: 30',
                      prefixIcon: const Icon(
                        Icons.breakfast_dining,
                        color: AppColors.primary,
                      ),
                      suffixText: 'g',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _proteinController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Protein/portion',
                      hintText: 'Ex: 20',
                      prefixIcon: const Icon(
                        Icons.egg,
                        color: AppColors.primary,
                      ),
                      suffixText: 'g',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _fatController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Fat/portion',
                      hintText: 'Ex: 10',
                      prefixIcon: const Icon(
                        Icons.fastfood,
                        color: AppColors.primary,
                      ),
                      suffixText: 'g',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Consumer<EntryViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          spacing: 12,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: viewModel.isLoading ? null : _onAddFood,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text('Add Food', style: AppTextStyle.button),
              ),
            ),
            if (_foodItems.isNotEmpty)
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.meal,
                  ),
                  onPressed: viewModel.isLoading ? null : _onSaveMeal,
                  icon: viewModel.isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : const Icon(Icons.save, color: Colors.white),
                  label: Text('Save Meal', style: AppTextStyle.button),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFoodList() {
    double totalCalories = _foodItems.fold(
      0.0,
      (sum, food) => sum + food.totalCalories,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Foods in Meal (${_foodItems.length})',
              style: AppTextStyle.subtitle,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.meal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: Text(
                'Total: ${totalCalories.toStringAsFixed(0)} kcal',
                style: TextStyle(
                  color: AppColors.meal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_foodItems.length, (index) {
          return FoodItemCard(
            food: _foodItems[index],
            onRemove: () => _removeFood(index),
          );
        }),
      ],
    );
  }
}
