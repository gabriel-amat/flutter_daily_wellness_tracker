import 'package:daily_wellness_tracker/core/helper/format_data.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';
import 'package:flutter/material.dart';

class EntryCard extends StatelessWidget {
  final ConsumptionItemEntity item;

  const EntryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isCalorie = item.type == ConsumptionType.calories;
    final icon = isCalorie ? Icons.local_fire_department : Icons.water_drop;
    final color = isCalorie ? AppColors.primary : Colors.blue.shade600;
    final unit = isCalorie ? 'calories' : 'ml';
    final value = item.value.toStringAsFixed(0);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          '$value $unit',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          FormatDate.formatString1(value: item.date),
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ),
    );
  }
}
