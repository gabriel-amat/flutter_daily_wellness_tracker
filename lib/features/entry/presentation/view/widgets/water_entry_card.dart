import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/viewModel/entry_view_model.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterEntryCard extends StatefulWidget {
  const WaterEntryCard({super.key});

  @override
  State<WaterEntryCard> createState() => _WaterEntryCardState();
}

class _WaterEntryCardState extends State<WaterEntryCard> {
  final _formKey = GlobalKey<FormState>();
  final waterController = TextEditingController();
  late EntryViewModel entryViewModel;
  late CustomSnack snack;

  @override
  void initState() {
    snack = context.read<CustomSnack>();
    entryViewModel = context.read<EntryViewModel>();
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    waterController.dispose();
    super.dispose();
  }

  void _onAddEntry() {
    if (!_formKey.currentState!.validate()) {
      snack.error(text: 'Type a valid amount of water');
      return;
    }

    final value = double.tryParse(waterController.text);

    if (value == null) return;

    entryViewModel.saveWaterEntry(milliliters: value);
    snack.success(text: '${value.toStringAsFixed(0)} ml of water added!');

    waterController.clear();
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
                controller: waterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Ex: 500',
                  prefixIcon: Icon(
                    Icons.water_drop,
                    color: Colors.blue.shade600,
                  ),
                  suffixText: 'ml',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the water amount';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Water amount must be greater than zero';
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
                        backgroundColor: Colors.blue.shade600,
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
                              'Add Water',
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
