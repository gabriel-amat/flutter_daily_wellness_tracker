import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/entry/viewModel/entry_view_model.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewEntryCard extends StatefulWidget {
  final EntryType selectedType;

  const NewEntryCard({super.key, required this.selectedType});

  @override
  State<NewEntryCard> createState() => _NewEntryCardState();
}

class _NewEntryCardState extends State<NewEntryCard> {
  final _formKey = GlobalKey<FormState>();
  final entryController = TextEditingController();
  late EntryViewModel entryViewModel;
  late CustomSnack snack;

  @override
  void initState() {
    snack = context.read<CustomSnack>();
    entryViewModel = context.read<EntryViewModel>();
    super.initState();
  }

  @override
  dispose() {
    _formKey.currentState?.dispose();
    entryController.dispose();
    super.dispose();
  }

  void _onAddEntry() {
    if (!_formKey.currentState!.validate()) {
      snack.error(
        text: widget.selectedType == EntryType.calorie
            ? 'Type a valid number of calories'
            : 'Type a valid amount of water',
      );
      return;
    }

    final value = double.tryParse(entryController.text);

    if (value != null) {
      if (widget.selectedType == EntryType.calorie) {
        entryViewModel.saveCalorieEntry(value: value);
        snack.success(text: '${value.toStringAsFixed(0)} calories added!');
      } else {
        entryViewModel.saveWaterEntry(value: value);
        snack.success(text: '${value.toStringAsFixed(0)} ml of water added!');
      }
      entryController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  hintText: widget.selectedType == EntryType.calorie
                      ? 'Ex: 250'
                      : 'Ex: 500',
                  prefixIcon: Icon(
                    widget.selectedType == EntryType.calorie
                        ? Icons.local_fire_department
                        : Icons.water_drop,
                    color: widget.selectedType == EntryType.calorie
                        ? AppColors.primary
                        : Colors.blue.shade600,
                  ),
                  suffixText: widget.selectedType == EntryType.calorie ? 'cal' : 'ml',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.selectedType == EntryType.calorie
                        ? 'Please enter the calories'
                        : 'Please enter the water amount';
                  }
                  if (double.parse(value) <= 0) {
                    return widget.selectedType == EntryType.calorie
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
                        backgroundColor: widget.selectedType == EntryType.calorie
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
                              widget.selectedType == EntryType.calorie
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
}
