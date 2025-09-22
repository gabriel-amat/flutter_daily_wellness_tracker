import 'package:daily_wellness_tracker/core/routes/navigation_controller.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/viewModel/entry_view_model.dart';
import 'package:daily_wellness_tracker/features/entry/routes/entry_pages.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/meal_entity.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealCard extends StatefulWidget {
  final MealEntity mealEntity;

  const MealCard({super.key, required this.mealEntity});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late NavigationController navigationController;
  late CustomSnack snack;
  late EntryViewModel viewModel;

  @override
  void initState() {
    navigationController = context.read<NavigationController>();
    snack = context.read<CustomSnack>();
    viewModel = context.read<EntryViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.restaurant, color: Colors.orange),
        title: Text(widget.mealEntity.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.mealEntity.foods.length} food items'),
            Text('${widget.mealEntity.totalCalories.toStringAsFixed(0)} cal'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ];
          },
          onSelected: (value) async {
            if (value == 'edit') {
              navigationController.push(
                routeName: EntryPages.editMeal,
                args: widget.mealEntity,
              );
            } else if (value == 'delete') {
              final confirm = await _showDeleteConfirmationDialog();
              if (confirm == true) {
                viewModel.removeMeal(meal: widget.mealEntity);
                snack.success(text: 'Meal entry deleted');
              }
            }
          },
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
