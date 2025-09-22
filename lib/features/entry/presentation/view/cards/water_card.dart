import 'package:daily_wellness_tracker/core/routes/navigation_controller.dart';
import 'package:daily_wellness_tracker/features/entry/presentation/viewModel/entry_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/data/models/water_intake_entity.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterCard extends StatefulWidget {
  final WaterIntakeEntity waterEntry;

  const WaterCard({super.key, required this.waterEntry});

  @override
  State<WaterCard> createState() => _WaterCardState();
}

class _WaterCardState extends State<WaterCard> {
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
        leading: const Icon(Icons.water_drop, color: Colors.blue),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Water Entry'),
            Text('${widget.waterEntry.amount.toStringAsFixed(0)} ml'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
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
            if (value == 'delete') {
              final confirm = await _showDeleteConfirmationDialog();
              if (confirm == true) {
                viewModel.removeWaterEntry(waterEntry: widget.waterEntry);
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
